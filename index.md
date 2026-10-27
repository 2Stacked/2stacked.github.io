---
lang: en
permalink: /
translation: /fr/
description: Apps by 2Stacked Development.
---

2Stacked Development makes apps for iPhone.

{% for entry in site.data.apps -%}
- [{{ entry[1].name }}](/{{ entry[0] }}/): {{ entry[1].tagline.en }}
{% endfor %}
