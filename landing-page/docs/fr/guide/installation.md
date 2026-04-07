---
layout: doc
---

# Installation

## Prérequis

- **macOS 14.0+** (Sonoma ou ultérieur)
- MacBook Pro ou MacBook Air **avec encoche** (2021 ou ultérieur)
- [GitHub Copilot CLI](https://docs.github.com/fr/copilot/github-copilot-in-the-cli) installé et authentifié

## Option 1 : Télécharger la version publiée (recommandé)

1. Accédez à la [page des versions](https://github.com/lordmos/copilot-island/releases/latest)
2. Téléchargez `CopilotIsland.dmg`
3. Ouvrez le DMG et faites glisser Copilot Island dans votre dossier Applications
4. Lancez Copilot Island depuis Applications (ou Spotlight)
5. L'application apparaît dans l'encoche de votre MacBook

## Option 2 : Compiler depuis les sources

```bash
# Cloner le dépôt
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# Lancer la configuration (installe XcodeGen, génère le projet Xcode)
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Ouvrir dans Xcode
open CopilotIsland.xcodeproj
```

Appuyez ensuite sur **⌘R** pour compiler et exécuter.

## Premier lancement

Au premier lancement, Copilot Island va :
1. Demander la permission d'accéder aux fichiers de votre répertoire personnel
2. Commencer à surveiller `~/.copilot/session-state/` automatiquement
3. Afficher une pastille rétractée dans l'encoche de votre MacBook

Aucune configuration supplémentaire n'est nécessaire — utilisez simplement `copilot` dans votre terminal !
