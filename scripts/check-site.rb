#!/usr/bin/env ruby
# Builds the site and checks the generated HTML: expected pages exist, nothing is loaded from another host,
# every language link has a counterpart that links back, and privacy pages name who to contact.
require "html-proofer"
require "nokogiri"
require "pathname"

ROOT = Pathname(__dir__).parent
SITE = ROOT / "_site"
ALLOWED_PREFIXES = ["/", "#", "mailto:", "https://2stacked.github.io", "https://apps.apple.com", "https://www.apple.com/legal/"].freeze
LANGS = %w[en fr].freeze

APP_PAGES = ["", "privacy/", "support/"].freeze
EXPECTED_PAGES = (["/", "/fr/", "/404.html"] +
  %w[propertyledger].flat_map { |app| APP_PAGES.flat_map { |p| ["/#{app}/#{p}", "/#{app}/fr/#{p}"] } }).freeze

def file_for(url)
  path = url.sub(%r{\Ahttps://2stacked\.github\.io}, "")
  path.end_with?("/") ? SITE / path.delete_prefix("/") / "index.html" : SITE / path.delete_prefix("/")
end

def url_for(file)
  rel = "/" + file.relative_path_from(SITE).to_s
  rel.end_with?("/index.html") ? rel.delete_suffix("index.html") : rel
end

failures = []

Dir.chdir(ROOT) do
  system("bundle", "exec", "jekyll", "build", "--quiet") or abort("jekyll build failed")
end

EXPECTED_PAGES.each { |url| failures << "missing page #{url}" unless file_for(url).file? }

pages = Pathname.glob(SITE / "**/*.html")
pages.each do |file|
  url = url_for(file)
  doc = Nokogiri::HTML(file.read)

  lang = doc.at("html")&.[]("lang")
  failures << "#{url}: <html lang> is #{lang.inspect}" unless LANGS.include?(lang)
  failures << "#{url}: has a <script>" if doc.at("script")

  doc.xpath("//@src | //@href").each do |attr|
    value = attr.value
    next if ALLOWED_PREFIXES.any? { |p| value.start_with?(p) } || !value.match?(%r{\A[a-z]+:|\A//}i)
    failures << "#{url}: off-site #{attr.name}=#{value}"
  end

  if url.end_with?("/privacy/")
    text = doc.at("main")&.text.to_s
    failures << "#{url}: privacy page doesn't name 2Stacked Development" unless text.include?("2Stacked Development")
    failures << "#{url}: privacy page has no mailto:mail@husseindev.com link" unless doc.at('main a[href="mailto:mail@husseindev.com"]')
    failures << "#{url}: privacy page has no last-updated date" unless doc.at("main .updated time[datetime]")
  end

  next if url == "/404.html"

  alternates = doc.css("link[rel=alternate][hreflang]")
  failures << "#{url}: expected 2 hreflang links, found #{alternates.size}" and next unless alternates.size == 2
  own = alternates.find { |l| l["hreflang"] == lang }
  other = alternates.find { |l| l["hreflang"] != lang }
  failures << "#{url}: no hreflang link for its own language" and next unless own && other
  failures << "#{url}: own hreflang points to #{own["href"]}" unless url_for(file_for(own["href"])) == url

  target = file_for(other["href"])
  unless target.file?
    failures << "#{url}: translation #{other["href"]} does not exist"
    next
  end
  back = Nokogiri::HTML(target.read).css("link[rel=alternate][hreflang]").map { |l| url_for(file_for(l["href"])) }
  failures << "#{url}: translation #{other["href"]} does not link back" unless back.include?(url)
end

css = (SITE / "assets/site.css")
if css.file?
  failures << "site.css uses @import" if css.read.include?("@import")
  failures << "site.css loads a url(http…)" if css.read.match?(/url\(\s*['"]?https?:/)
else
  failures << "missing assets/site.css"
end

begin
  HTMLProofer.check_directory(SITE.to_s, disable_external: true, checks: ["Links", "Images"], log_level: :error).run
rescue RuntimeError, SystemExit
  failures << "html-proofer found broken links or images (listed above)"
end

if failures.empty?
  puts "check-site: #{pages.size} pages OK"
else
  puts failures.map { |f| "FAIL #{f}" }
  exit 1
end
