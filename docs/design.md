# 2Stacked Development public site — design

Date: 2026-10-27 · Drives: issue 2Stacked/propertyledger-app#135 (privacy policy URL, support URL)

> This file is drafted here only to be reviewed. It moves into the new site repo as `docs/design.md` and is not
> committed to propertyledger-app.

## Goal

One public site for every 2Stacked Development app, with each app's privacy policy, support page and short landing
page, in English and French. App Store Connect accepts the PropertyLedger URLs, and the policy says only what the
app's privacy manifests say (`PropertyLedger/Resources/PrivacyInfo.xcprivacy`,
`PropertyLedgerWidget/PrivacyInfo.xcprivacy`, spec `059-privacy-manifest`).

Out of scope: app source code (it stays in each app's repo), store screenshots, listing text, App Privacy answers.
Those are the rest of issue 135.

## Decisions

| Decision | Choice |
| --- | --- |
| Repo | New public repo `2Stacked/2stacked.github.io` (the org's root Pages site) |
| Hosting | GitHub Pages, deployed from `main` by Pages' built-in Jekyll build (no Actions workflow) |
| URLs | `https://2stacked.github.io/<app>/`, `…/<app>/privacy/`, `…/<app>/support/`; French under `…/<app>/fr/…` |
| Business name | **2Stacked Development** (the developer named in every policy and footer) |
| Contact | `mail@husseindev.com`, set once in `_config.yml` |
| Languages | English and French for every page at launch |
| Build | Jekyll + one shared layout, Markdown pages, one hand-written stylesheet |
| Custom domain | None now. Adding one later is a `CNAME` file; GitHub redirects the `github.io` URLs |

The App Store Connect URLs for PropertyLedger:

- Privacy Policy URL: `https://2stacked.github.io/propertyledger/privacy/`
- Support URL: `https://2stacked.github.io/propertyledger/support/`
- French listing: the same paths under `/propertyledger/fr/`

## Repo layout

```
2stacked.github.io/
  _config.yml              title "2Stacked Development", contact email, permalink style, lang defaults
  _data/apps.yml           one entry per app: slug, name, tagline (en/fr), App Store URL (empty until live)
  _data/strings.yml        layout's own words in en and fr ("Support", "Privacy", "Last updated", "Français"/"English")
  _layouts/default.html    head, header, {{ content }}, footer
  assets/site.css          the only stylesheet
  assets/<app>/icon.png    app icon shown in the header
  index.md                 2Stacked Development home: list of apps from apps.yml
  fr/index.md              same in French
  propertyledger/
    index.md               landing page
    privacy.md             privacy policy
    support.md             support page
    fr/index.md, fr/privacy.md, fr/support.md
  404.html                 plain not-found page with a link home
  README.md                how to preview locally and how to add an app
  docs/design.md           this document
```

## Layout

Every page sets its front matter; the layout reads it and `_data/` so nothing is repeated per page:

```yaml
---
layout: default
app: propertyledger            # key into _data/apps.yml; omit on the 2Stacked home pages
title: Privacy Policy
lang: en                       # en | fr — sets <html lang> and picks _data/strings.yml words
permalink: /propertyledger/privacy/
translation: /propertyledger/fr/privacy/
last_updated: 2026-10-27       # shown under the title on privacy and support pages
---
```

- **Header**: the app's icon and name, linking to the app's landing page (or "2Stacked Development" on the home
  pages), and a link to `translation` labelled with the other language's name.
- **Footer**: the app's Support and Privacy links in the page's language, the contact address as a `mailto:` link,
  and "© <year> 2Stacked Development".
- **Head**: title, `<meta name="description">`, `<link rel="alternate" hreflang>` pairs from `translation`, and a
  viewport tag. No analytics, no web fonts, no scripts, nothing loaded from another host.
- **Style**: system font stack, max line length about 70 characters, light and dark through
  `prefers-color-scheme`, readable at phone width with no horizontal scrolling.

Adding an app = one folder copied from `propertyledger/`, one entry in `_data/apps.yml`, one icon.

## PropertyLedger page content

### Privacy policy (en; fr says the same)

Based on what the app does today:

- **Who**: PropertyLedger is made by 2Stacked Development. Contact: mail@husseindev.com.
- **Summary**: 2Stacked Development collects no data. There are no accounts, no analytics, no advertising, no
  tracking and no third-party SDKs. The app makes no network requests of its own.
- **Where your data lives**: on your device, in the app's own storage. The home-screen widget reads a summary the
  app writes on the same device.
- **iCloud sync (optional, off by default)**: when you turn it on, your records and photos sync through Apple's
  iCloud to your own private iCloud database, under your Apple Account. 2Stacked Development cannot see that data.
  Apple's privacy policy covers iCloud.
- **Camera and photos**: used only when you choose to attach a picture. Photos are stored with the record.
- **Contacts**: when you pick a contact to fill in a person, only that contact's details are copied into the app.
  The app does not read your contact list.
- **Files**: documents you attach are copied into the app.
- **Reminders**: scheduled as notifications on your device. Nothing is sent to a server.
- **Sharing**: the Home Report PDF and attachments leave the app only when you share them through the share sheet,
  to the place you choose.
- **Deleting your data**: delete records in the app, or delete the app. With iCloud sync on, also remove the app's
  data in Settings › [your name] › iCloud.
- **Children**: not directed at children; collects nothing from anyone.
- **Changes**: changes are posted on this page with a new "Last updated" date.

This matches the manifests: no tracking and no collected data. The manifests' one required-reason API, UserDefaults
(CA92.1), stores app settings on the device and is not collection, so the policy does not list it.

### Support page

- How to reach us: mail@husseindev.com, with a note of what to include (iOS version, app version, what happened).
- Short FAQ: Is my data backed up? (only with iCloud sync on, or the device's own backup) · How do I move to a new
  iPhone? (iCloud sync, or an iPhone backup) · How do I share my home's record? (Home Report, in About this home) ·
  How do I delete everything? (link to the privacy policy's section).
- Links to the privacy policy and the landing page.

### Landing page

App name, one-line tagline framed as the home's record (not a maintenance app, per propertyledger-app's AGENTS.md),
three or four short lines on what it keeps (items, spaces, documents, people, spending, projects, timeline, Home
Report), and an App Store badge once `apps.yml` has the URL (hidden until then).

## Keeping the policy true

- propertyledger-app gets one line in AGENTS.md, through Spec Kit, next to the privacy-manifest convention: a
  change that updates a `PrivacyInfo.xcprivacy` or adds a permission, network call or SDK also updates
  `2Stacked/2stacked.github.io/propertyledger/privacy.md` and its French copy.
- The site's README lists the same rule from the other side.

## Checking it works

- Local preview: `bundle exec jekyll serve` with the `github-pages` gem (README documents it), or push and look.
- After the first deploy, open each of the six PropertyLedger URLs and the two home pages, with and without the
  trailing slash, in light and dark mode and at phone width.
- `curl -sI` each App Store URL returns 200.
- A view-source check shows no `<script>` and no off-site requests.
- The French pages read as French (written, not machine-translated word for word) and each language link lands on
  the matching page.

## Steps outside the repo

1. Create the public repo `2Stacked/2stacked.github.io` (needs your OK; it is public).
2. Settings › Pages: deploy from branch `main`, folder `/`.
3. Paste the two URLs into App Store Connect (and the `fr/` ones in the French localization) — by you.
