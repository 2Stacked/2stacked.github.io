---
lang: fr
permalink: /fr/
translation: /
description: Les applications de 2Stacked Development.
---

2Stacked Development crée des applications pour iPhone.

{% for entry in site.data.apps -%}
- [{{ entry[1].name }}](/{{ entry[0] }}/fr/) : {{ entry[1].tagline.fr }}
{% endfor %}
