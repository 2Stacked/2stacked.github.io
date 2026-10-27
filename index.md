---
lang: en
permalink: /
translation: /fr/
description: 2Stacked Development is Hussein Sakr, a solo developer building apps, web services and the cloud setup behind them.
---

2Stacked Development is Hussein Sakr, a solo developer. I build software end to end: apps, web services, the cloud
setup they run on, and tools that put AI to work. The same person designs, builds and supports every one of them.

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
