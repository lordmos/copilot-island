---
layout: home

hero:
  name: "Copilot Island"
  text: "Votre encoche MacBook, propulsée par GitHub Copilot"
  tagline: Surveillez les sessions Copilot CLI et parcourez les conversations IA — directement depuis l'encoche.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Télécharger pour Mac
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: Voir sur GitHub
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: Démarrage rapide →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: Surveillance en direct
    details: Observez chaque session Copilot CLI en temps réel depuis l'encoche de votre MacBook. Ne manquez jamais ce que fait l'IA.

  - icon: ⚡
    title: Fil d'activité des outils
    details: Voyez exactement quels outils Copilot utilise — écritures de fichiers, commandes shell, recherches web — avec les arguments, tout dans l'encoche.

  - icon: 💬
    title: Historique complet des conversations
    details: Parcourez toute la conversation avec un rendu Markdown élégant. Blocs de code et résultats d'outils inclus.

  - icon: 🎨
    title: Design inspiré Copilot
    details: Conçu avec le langage de design GitHub. Palette vert sauge apaisante, thème sombre et animations fluides natives sur macOS.

  - icon: 🔓
    title: Entièrement open source
    details: Licence Apache 2.0. Inspectez le code, contribuez des fonctionnalités, signalez des bugs. Construit avec ❤️ par la communauté.
---

## Comment ça fonctionne

```bash
# 1. Installez Copilot Island (téléchargez depuis les Releases)
# 2. Lancez votre session Copilot CLI normalement
copilot "Ajouter des tests unitaires pour le module d'authentification"

# 3. Copilot Island détecte automatiquement la session
#    et l'affiche dans l'encoche de votre MacBook — aucune configuration !
```

> Copilot Island surveille `~/.copilot/session-state/` et diffuse les événements en temps réel depuis le journal JSONL natif de Copilot CLI. Aucune configuration requise.

## Configuration requise

- macOS 14.0+ (Sonoma ou version ultérieure)
- MacBook Pro ou MacBook Air **avec encoche** (2021 ou version ultérieure)
- GitHub Copilot CLI installé et authentifié
