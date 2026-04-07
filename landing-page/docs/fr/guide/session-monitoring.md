---
layout: doc
---

# Surveillance des sessions

La fonctionnalité principale de Copilot Island est la surveillance en temps réel de vos sessions GitHub Copilot CLI.

## Comment les sessions sont détectées

Copilot Island surveille `~/.copilot/session-state/` à l'aide de **FSEvents** de macOS — la même API de notification du système de fichiers à faible latence utilisée par Xcode et Spotlight. Lorsque le CLI Copilot crée un nouveau répertoire de session, Copilot Island le détecte en quelques millisecondes.

```
~/.copilot/session-state/
└── {UUID}/                    ← le nouveau répertoire déclenche la détection
    ├── workspace.yaml         ← métadonnées de la session
    └── events.jsonl           ← flux d'événements (ajouté en temps réel)
```

Aucun hook, aucun plugin, aucune modification du CLI requise.

## Cartes de session

Chaque session est affichée sous forme de carte dans le panneau de l'encoche, montrant :

| Champ | Description |
|-------|-------------|
| 🟢 Point de statut | Vert = active, Gris = terminée |
| Chemin du projet | Le `cwd` depuis `workspace.yaml` |
| Branche Git | Branche actuelle (si dans un dépôt git) |
| Résumé de session | Résumé auto-généré par le CLI Copilot |
| Temps écoulé | Temps depuis le début de la session |

## Flux d'événements

Dans chaque session, Copilot Island suit `events.jsonl` et traite ces types d'événements :

| Type d'événement | Signification |
|-----------------|---------------|
| `session.start` | Une nouvelle session Copilot CLI a démarré |
| `user.message` | Vous avez envoyé un message à Copilot |
| `assistant.turn_start` | Copilot a commencé à réfléchir/répondre |
| `assistant.message` | Copilot a produit une réponse |
| `tool.execution_start` | Copilot est sur le point d'exécuter un outil |
| `tool.execution_complete` | L'outil s'est terminé (succès ou erreur) |
| `assistant.turn_end` | Copilot a complété son tour de réponse |
| `abort` | La session a été interrompue par l'utilisateur |
| `session.shutdown` | Le processus Copilot CLI s'est arrêté |

## Sessions multiples

Copilot Island suit **toutes les sessions simultanées**. Si vous avez plusieurs fenêtres de terminal exécutant `copilot`, chaque session apparaît comme une carte séparée. Les sessions sont triées par la plus récemment active.

## Rétention des sessions

Les sessions terminées restent visibles pendant le lancement actuel de l'application. Les sessions ne sont pas conservées entre les redémarrages de l'application (pour garder l'application légère et respecter votre vie privée).

## Confidentialité

Copilot Island lit les données de session **localement** depuis votre Mac. Rien n'est téléchargé ou partagé. La fonctionnalité de chat avec l'API GitHub Models est la seule fonctionnalité réseau, et elle est entièrement optionnelle.
