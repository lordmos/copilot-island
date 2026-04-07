---
layout: doc
---

# Configuration

Copilot Island nécessite une configuration minimale et fonctionne immédiatement.

## Panneau de paramètres

Accédez aux paramètres en cliquant sur l'**icône de menu ⋯** dans le panneau de l'encoche développé, puis en sélectionnant **Paramètres**.

### Effets sonores

Activez ou désactivez la sonnerie de fin et le son d'échec :

- **Son de fin** — se joue lorsque l'agent termine une tâche (`session.task_complete` → `assistant.turn_end`)
- **Son d'échec** — se joue sur `abort`, `session.error`, ou `session.shutdown` inattendu

### À propos et mises à jour

L'onglet **À propos** dans les Paramètres affiche la version actuelle de l'application et vous permet de **Vérifier les mises à jour** (propulsé par Sparkle). Copilot Island vous notifiera lorsqu'une nouvelle version est disponible sur GitHub.

## Surveillance des sessions

Copilot Island surveille automatiquement `~/.copilot/session-state/` pour détecter les modifications.  
Aucune configuration nécessaire — ça fonctionne tout seul.

Au démarrage, seule la **tâche en cours** (événements depuis le dernier `user.message`) est chargée pour garder l'interface rapide. L'historique plus ancien n'est pas rejoué.

## Permissions macOS

Au premier lancement, accordez cette permission lorsqu'elle est demandée :

- **Fichiers et dossiers** → Autoriser l'accès en lecture aux fichiers de session Copilot CLI dans votre répertoire personnel
