---
lang: fr
permalink: /fr/
translation: /
description: 2Stacked Development est un studio indépendant mené par un seul développeur, qui crée des logiciels axés sur la protection de la vie privée.
---

2Stacked Development est un studio de logiciels indépendant dont la mission est de créer des technologies qui
changent vraiment la vie des gens. En tant que studio d'une seule personne, je me consacre à des logiciels pratiques
et soigneusement conçus, qui règlent de vrais problèmes, écartent la complexité inutile et placent les gens au
premier plan.

La vie privée est au cœur de tout ce que je crée. Vos données vous appartiennent, pas aux annonceurs ni aux
entreprises derrière vos logiciels. Je crois qu'un bon logiciel ne devrait pas se payer au prix de votre vie privée :
je conçois donc en limitant les données au strict nécessaire, en gardant l'information sur votre appareil ou dans un
espace que vous contrôlez, sans pistage ni collecte inutiles, et sans jamais vendre de renseignements personnels. Pas
de publicité, et pas de compte à moins qu'il soit vraiment nécessaire.

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
