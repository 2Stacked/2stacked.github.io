---
lang: fr
permalink: /fr/
translation: /
description: 2Stacked Development est un studio indépendant mené par un seul développeur, qui crée des logiciels axés sur la protection de la vie privée.
---

2Stacked Development est un studio de logiciels indépendant mené par un seul développeur, qui crée des logiciels
axés sur la protection de la vie privée, de l'application jusqu'à l'infrastructure infonuagique qui la fait tourner.

Concrètement, vos données restent les vôtres : elles demeurent sur votre appareil ou dans un espace que vous
contrôlez, et rien n'est recueilli, pisté ni vendu. Il n'y a pas de publicité, ni de compte à moins qu'il soit vraiment nécessaire.
PropertyLedger pour iPhone est la première application, et d'autres suivront.

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
