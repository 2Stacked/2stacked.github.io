---
lang: fr
permalink: /fr/
translation: /
description: 2Stacked Development, c'est Hussein Sakr, un développeur indépendant qui crée des applications, des services web et l'infrastructure infonuagique qui les fait tourner.
---

2Stacked Development, c'est Hussein Sakr, un développeur indépendant. Je conçois des logiciels de bout en bout : des
applications, des services web, l'infrastructure infonuagique sur laquelle ils tournent et des outils qui mettent
l'IA au travail. La même personne conçoit, développe et soutient chacun d'eux.

## Applications

{% for entry in site.data.apps -%}
- **[{{ entry[1].name }}](/{{ entry[0] }}/fr/)** ({{ entry[1].platform }}) : {{ entry[1].tagline.fr }}
{% endfor %}

{% if site.sponsor_url != "" -%}
## Soutenir le travail

Si quelque chose que je crée vous est utile, vous pouvez [commanditer mon travail sur GitHub]({{ site.sponsor_url }}).
{%- endif %}

## Me joindre

Questions, idées ou projet à réaliser : [{{ site.contact_email }}](mailto:{{ site.contact_email }})
