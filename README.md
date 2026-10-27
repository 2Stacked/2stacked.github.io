# 2stacked.github.io

The public site for 2Stacked Development's apps: each app's landing page, privacy policy and support page, in
English and French. Served by GitHub Pages from `main` at <https://2stacked.github.io/>.

| Page | English | French |
| --- | --- | --- |
| Home | `/` | `/fr/` |
| PropertyLedger | `/propertyledger/` | `/propertyledger/fr/` |
| PropertyLedger privacy (App Store Privacy Policy URL) | `/propertyledger/privacy/` | `/propertyledger/fr/privacy/` |
| PropertyLedger support (App Store Support URL) | `/propertyledger/support/` | `/propertyledger/fr/support/` |

The design and the plan it was built from are in [docs/design.md](docs/design.md) and [docs/plan.md](docs/plan.md).

## Preview locally

GitHub Pages builds with Jekyll 3 through the `github-pages` gem, which needs Ruby 3.3 (Ruby 4 can't install it).

```sh
brew install ruby@3.3
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
bundle config set --local path vendor/bundle
bundle install
bundle exec jekyll serve        # http://localhost:4000
```

## Checks

```sh
bundle exec ruby scripts/check-site.rb
```

It builds the site and fails on: a missing page, a `<script>`, anything loaded or linked from another site (except
the App Store and Apple's legal pages), a page whose language link has no counterpart linking back, a privacy page
without "2Stacked Development", the contact address or a last-updated date, and broken internal links or images.
CI (`.github/workflows/check.yml`) runs it on every pull request and every push to `main`.

The site loads nothing from another host — no scripts, fonts or analytics — so the site itself collects nothing.
Keep it that way.

## Adding an app

1. Copy `propertyledger/` (including `fr/`) to `<slug>/` and rewrite the pages. Every page sets `app`, `lang`,
   `permalink` and `translation` in its front matter; privacy and support pages also set `last_updated`.
2. Add an entry under `<slug>` in `_data/apps.yml` (name, English and French tagline, icon, App Store URL once live).
3. Add a 256×256 icon at `assets/<slug>/icon.png` (`sips -Z 256 AppIcon.png --out assets/<slug>/icon.png`).
4. Add the slug to the list in `EXPECTED_PAGES` in `scripts/check-site.rb`, and run the checks.

## Keeping a privacy policy true

A privacy page must say only what its app does. When an app's `PrivacyInfo.xcprivacy`, permissions, network calls
or third-party SDKs change, update its `privacy.md` and `fr/privacy.md` in the same week, and bump `last_updated`
on both.

The contact address lives only in `_config.yml` (`contact_email`).
