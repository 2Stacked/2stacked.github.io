# 2Stacked Development Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A public GitHub Pages site at `https://2stacked.github.io/` with PropertyLedger's landing, privacy and support pages in English and French, ready to paste into App Store Connect.

**Architecture:** A new repo `2Stacked/2stacked.github.io`, built by GitHub Pages' own Jekyll (no deploy workflow). One layout reads page front matter plus `_data/apps.yml` and `_data/strings.yml`. A Ruby check script builds the site and asserts on the generated HTML; it is the test for every task and also runs in a CI workflow on pull requests.

**Tech Stack:** Jekyll via the `github-pages` gem (the exact versions Pages uses), `html-proofer` and `nokogiri` for checks, Homebrew Ruby (system Ruby 2.6 is too old).

**Spec:** `docs/superpowers/specs/2026-10-27-2stacked-site-design.md` (copied into the new repo as `docs/design.md` in Task 1)

## Global Constraints

- Site root: `https://2stacked.github.io`, `baseurl: ""`. Page URLs end in `/` (`permalink:` set per page).
- Business name, everywhere: **2Stacked Development**. Contact: **mail@husseindev.com**, only from `site.contact_email`.
- Languages: `en` and `fr`. Every page has `lang` and `translation` front matter; every page has a counterpart.
- No `<script>`, no web fonts, no analytics, no request to any host except links to `https://apps.apple.com` and `mailto:`.
- PropertyLedger is presented as the home's record, never as a maintenance app.
- Policy claims must match `PropertyLedger/Resources/PrivacyInfo.xcprivacy`: no tracking, no collected data.
- Work happens in a new local folder `~/Projects/personal/2stacked.github.io` (outside propertyledger-app). Nothing is pushed until Task 5, which needs the user's OK because the repo is public.

## Review Focus

1. **A URL without the trailing slash** (`/propertyledger/privacy`) — Apple reviewers type or paste it that way; it must still load. Checked live in Task 5.
2. **A language link that lands on the wrong page or a 404** — the check script follows every `translation` and requires the target to link back (Task 1).
3. **An off-site request slipping in** (a theme's Google Fonts, a gem-injected script) — the check rejects any `src`/`href`/CSS `url()` to another host (Task 1).
4. **Phone width and dark mode** — the store link opens on an iPhone; no horizontal scroll, readable in dark mode. Checked by eye in Task 2 and live in Task 5.
5. **Policy drift** — a privacy page missing the business name, contact, or "Last updated" date. The check requires all three on every `privacy` page (Task 2).

---

### Task 1: Site skeleton, layout, checker and 2Stacked home pages

**Files:**
- Create: `Gemfile`, `.gitignore` (`_site/`, `.jekyll-cache/`, `vendor/`, `.bundle/`), `_config.yml`
- Create: `_data/strings.yml`, `_data/apps.yml` (empty map `{}` for now), `_layouts/default.html`, `assets/site.css`
- Create: `index.md`, `fr/index.md`, `404.html`
- Create: `scripts/check-site.rb`, `.github/workflows/check.yml`
- Create: `docs/design.md` (copy of the spec), `docs/plan.md` (copy of this plan)

**Interfaces:**
- Produces: front matter keys `layout, app, title, description, lang, permalink, translation, last_updated`; `site.data.strings[lang].{home, support, privacy, last_updated, other_language}`; `site.data.apps[slug].{name, tagline.en, tagline.fr, icon, app_store_url}`; `ruby scripts/check-site.rb` exits 0 on success, prints each failure and exits 1 otherwise; its `EXPECTED_PAGES` array is what later tasks extend.

- [ ] **Step 1: Set up tools**

Run: `brew install ruby` then put `$(brew --prefix ruby)/bin` first on `PATH`. `Gemfile`: `gem "github-pages", group: :jekyll_plugins`, and in `group :test`: `html-proofer`, `nokogiri`. Run `bundle install`.
Expected: `bundle exec jekyll -v` prints a version.

- [ ] **Step 2: Write the checker (`scripts/check-site.rb`)**

It runs `bundle exec jekyll build`, then over `_site/`:
- `EXPECTED_PAGES = ["/", "/fr/", "/404.html"]` — each must exist (`/x/` → `_site/x/index.html`).
- Every HTML page: `<html lang>` is `en` or `fr`; zero `<script>` elements; every `src`/`href` is relative, starts with `/`, `#`, `mailto:`, `https://2stacked.github.io` or `https://apps.apple.com`.
- Every page except `404.html` has exactly two `link[rel=alternate][hreflang]`, one for its own lang and one for the other; the other's target exists in `_site` and its own alternate points back.
- `assets/site.css` contains no `@import` and no `url(http`.
- `HTMLProofer.check_directory("_site", disable_external: true, checks: ["Links", "Images"]).run` passes.

- [ ] **Step 3: Run it to see it fail**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: FAIL — build error or missing `/`, `/fr/`.

- [ ] **Step 4: Write config, data, layout and CSS**

`_config.yml`: `title: 2Stacked Development`, `url: https://2stacked.github.io`, `baseurl: ""`, `contact_email: mail@husseindev.com`, `markdown: kramdown`, no `theme`, `exclude: [Gemfile, Gemfile.lock, scripts, docs, README.md, vendor]`, defaults `layout: default`.

`_data/strings.yml`:
```yaml
en: { home: "2Stacked Development", support: "Support", privacy: "Privacy", last_updated: "Last updated", other_language: "Français" }
fr: { home: "2Stacked Development", support: "Assistance", privacy: "Confidentialité", last_updated: "Dernière mise à jour", other_language: "English" }
```

`_layouts/default.html`: as the spec's Layout section — `<html lang="{{ page.lang }}">`, viewport, `<title>{{ page.title }} · {{ app.name | default: site.title }}</title>`, description meta, the two hreflang links (`page.url` and `page.translation`, both `| absolute_url`) only when `page.translation` is set, `assets/site.css`. The header's language link is likewise omitted without `page.translation`. Header: app icon + name linking to `/<app>/` (lang-aware: `/<app>/fr/`), or the site title linking to `/` or `/fr/`; link to `page.translation` labelled `strings.other_language`. Under the title, `strings.last_updated` + `page.last_updated` when set. Footer: when `page.app` is set, Support and Privacy links in the page's language; `mailto:` contact; `© {{ site.time | date: "%Y" }} 2Stacked Development`.

`assets/site.css`: system font stack, `max-width: 70ch`, 16px side padding, colour tokens on `:root` redefined under `@media (prefers-color-scheme: dark)`, images `max-width: 100%`.

- [ ] **Step 5: Write the home pages and 404**

`index.md` (`lang: en`, `permalink: /`, `translation: /fr/`): one line about 2Stacked Development, then a list of apps looping over `site.data.apps` (name, tagline in the page's lang, link). `fr/index.md` mirrors it. `404.html`: `lang: en`, `permalink: /404.html`, no `translation`, "Page not found" and a link to `/`.

- [ ] **Step 6: Run the checker**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: PASS.

- [ ] **Step 7: CI workflow**

`.github/workflows/check.yml`: on `pull_request` and `push` to `main`; `ruby/setup-ruby@v1` with `bundler-cache: true` and Ruby `3.3`; run `bundle exec ruby scripts/check-site.rb`.

- [ ] **Step 8: Commit**

```bash
git init -b main && git add -A && git commit -m "Site skeleton: layout, home pages, checker"
```

---

### Task 2: PropertyLedger pages in English

**Files:**
- Modify: `_data/apps.yml`, `scripts/check-site.rb` (`EXPECTED_PAGES`, privacy rule)
- Create: `assets/propertyledger/icon.png` (from `propertyledger-app/PropertyLedger/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png`, resized to 256×256 with `sips -Z 256`)
- Create: `propertyledger/index.md`, `propertyledger/privacy.md`, `propertyledger/support.md`

**Interfaces:**
- Consumes: Task 1's front matter keys, `site.data.apps`, checker.
- Produces: `site.data.apps.propertyledger`; pages at `/propertyledger/`, `/propertyledger/privacy/`, `/propertyledger/support/`, each with `translation` set to the `/propertyledger/fr/…` equivalent (built in Task 3).

- [ ] **Step 1: Extend the checker**

Add the three URLs and their three `fr/` equivalents to `EXPECTED_PAGES`. Add: every page whose URL ends in `/privacy/` contains the text `2Stacked Development`, a `mailto:mail@husseindev.com` link and the `last_updated` line.

- [ ] **Step 2: Run it to see it fail**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: FAIL — six PropertyLedger pages missing.

- [ ] **Step 3: Add the app entry and icon**

```yaml
propertyledger:
  name: PropertyLedger
  tagline:
    en: "The record of everything about your home."
    fr: "Le dossier de tout ce qui concerne votre maison."
  icon: /assets/propertyledger/icon.png
  app_store_url: ""
```

- [ ] **Step 4: Write the three English pages**

Content as the spec's "PropertyLedger page content" section, each bullet a short paragraph or list item under its own heading. `privacy.md` and `support.md` set `last_updated: 2026-10-27`. The landing page shows the App Store badge link only `{% if app.app_store_url != "" %}`. Contact appears only as `{{ site.contact_email }}`.

- [ ] **Step 5: Run the checker**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: FAIL only on the three `fr/` pages (missing, and the English pages' alternates point at them). Every other check passes.

- [ ] **Step 6: Look at it**

Run: `bundle exec jekyll serve`, open `http://localhost:4000/propertyledger/privacy/` in the browser pane at 375 px wide in light and dark.
Expected: no horizontal scroll, icon and name in header, footer links and contact visible.

- [ ] **Step 7: Commit**

```bash
git add -A && git commit -m "PropertyLedger landing, privacy and support pages (English)"
```

---

### Task 3: PropertyLedger pages in French

**Files:**
- Create: `propertyledger/fr/index.md`, `propertyledger/fr/privacy.md`, `propertyledger/fr/support.md`

**Interfaces:**
- Consumes: Task 2's pages (same structure, `translation` pointing back to the English URL), `strings.fr`.

- [ ] **Step 1: Run the checker to confirm the failing state**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: FAIL on the three missing `fr/` pages.

- [ ] **Step 2: Write the three French pages**

Same headings, order and facts as the English pages, written as natural Canadian French (the app's French catalogue in `propertyledger-app/PropertyLedger/Resources/Localizable.xcstrings` is the reference for terms: use its words for Space, Items, Home Report, To do). Same `last_updated`. iOS paths in French as the French UI names them (Réglages › [votre nom] › iCloud).

- [ ] **Step 3: Run the checker**

Run: `bundle exec ruby scripts/check-site.rb`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "PropertyLedger pages in French"
```

---

### Task 4: README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write it**

Sections: what the site is and its URLs; local preview (`brew install ruby`, `bundle install`, `bundle exec jekyll serve`); checks (`bundle exec ruby scripts/check-site.rb`, also run by CI); adding an app (copy `propertyledger/` including `fr/`, add an `apps.yml` entry and icon, add its six URLs to `EXPECTED_PAGES`); keeping a privacy page true (when an app's `PrivacyInfo.xcprivacy`, permissions, network calls or SDKs change, update its `privacy.md` and `fr/privacy.md` and bump `last_updated`).

- [ ] **Step 2: Run the checker** (README is excluded from the build, so the site must be unchanged)

Run: `bundle exec ruby scripts/check-site.rb`
Expected: PASS.

- [ ] **Step 3: Commit**

```bash
git add README.md && git commit -m "README: preview, checks, adding an app"
```

---

### Task 5: Publish (needs the user's OK before Step 1)

- [ ] **Step 1: Create the public repo and push**

Run: `gh repo create 2Stacked/2stacked.github.io --public --source . --push`
Expected: repo exists, `main` pushed, CI check run green (`gh run list --repo 2Stacked/2stacked.github.io`).

- [ ] **Step 2: Turn on Pages from `main`**

Run: `gh api -X POST repos/2Stacked/2stacked.github.io/pages -f "source[branch]=main" -f "source[path]=/"`
Expected: `gh api repos/2Stacked/2stacked.github.io/pages --jq .status` becomes `built` (wait on it, don't loop by hand).

- [ ] **Step 3: Check every live URL**

Run, for each of the 8 pages in `EXPECTED_PAGES` minus 404, with and without the trailing slash: `curl -sIL -o /dev/null -w "%{http_code} %{url_effective}\n" <url>`
Expected: every line `200`. `https://2stacked.github.io/nope/` returns `404` with the custom page.

- [ ] **Step 4: Look at it on a phone width**

Open `https://2stacked.github.io/propertyledger/privacy/` and its French page in the browser pane at 375 px, light and dark; follow the language link both ways.
Expected: as Task 2 Step 6.

---

### Task 6: Hand-offs (no code here)

- [ ] **Step 1: Tell the user the App Store Connect values**

Privacy Policy URL `https://2stacked.github.io/propertyledger/privacy/`, Support URL `https://2stacked.github.io/propertyledger/support/`, and the `fr/` pair for the French localization. They paste them; tick those two boxes on 2Stacked/propertyledger-app#135 only after they confirm.

- [ ] **Step 2: Propose the propertyledger-app follow-up**

A separate Spec Kit change in propertyledger-app (`/speckit-specify`): one line in AGENTS.md next to the privacy-manifest convention — a change that updates a `PrivacyInfo.xcprivacy` or adds a permission, network call or SDK also updates `2Stacked/2stacked.github.io/propertyledger/privacy.md` and its French copy. Remove `docs/superpowers/` from the propertyledger-app worktree once the copies live in the site repo.
