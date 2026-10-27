---
lang: en
permalink: /
translation: /fr/
description: 2Stacked Development is an independent studio run by a single developer, building privacy-first software.
---

2Stacked Development is an independent software studio run by a single developer, building privacy-first
software from the app to the cloud behind it.

Privacy-first means your data stays yours: it stays on your device or in storage you control, and nothing is
collected, tracked or sold. There are no ads, and no accounts unless one is truly needed. PropertyLedger for iPhone is the first
release, with more to come.

## Apps

{% for entry in site.data.apps -%}
- **[{{ entry[1].name }}](/{{ entry[0] }}/)** ({{ entry[1].platform }}): {{ entry[1].tagline.en }}
{% endfor %}

{% if site.sponsor_url != "" -%}
## Support the work

If something I make is useful to you, you can [sponsor my work on GitHub]({{ site.sponsor_url }}).
{%- endif %}

## Get in touch

Questions, ideas or work you'd like built: [{{ site.contact_email }}](mailto:{{ site.contact_email }})
