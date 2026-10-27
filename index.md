---
lang: en
permalink: /
translation: /fr/
description: 2Stacked Development is an independent studio run by a single developer, building privacy-first software.
---

2Stacked Development is an independent software studio with a mission to build technology that makes a meaningful
difference in people's lives. As a one-person studio, I focus on creating practical, thoughtfully designed software
that solves real problems, challenges unnecessary complexity, and puts people first.

Privacy is at the heart of everything I build. Your data belongs to you, not to advertisers or the companies behind
your software. I believe great software shouldn't come at the cost of your privacy, so I build with data
minimization in mind: keeping information on your device or in storage you control, with no unnecessary tracking,
data collection, or selling of personal information. No ads, and no accounts unless they're genuinely needed.

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
