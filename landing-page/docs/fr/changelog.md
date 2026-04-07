---
layout: doc
---

# Journal des modifications

Toutes les modifications notables apportées à Copilot Island sont documentées ici.

---

## v0.1.8 — 2026-04-07

### Fonctionnalités
- **Mise à jour automatique via Sparkle** — Copilot Island vérifie désormais automatiquement les mises à jour à l'aide du framework Sparkle. Les mises à jour sont servies de manière sécurisée via GitHub Pages.

### Correctifs
- Ajustements de l'affichage de la version de l'application et de la largeur de mise en page du menu
- Configuration de `SUFeedURL` Sparkle pour une détection fiable des mises à jour

---

## v0.1.7 — 2026-04-06

Cette version est une refonte majeure de l'interface de l'encoche, du système d'événements et des effets sonores.

### Fonctionnalités
- **Machine à états de l'aperçu** — L'icône d'aperçu gauche s'anime en fonction de l'état de la session : respiration inactive, pulsation en cours de travail, trophée 🏆 de 3 secondes lors de la tâche terminée, échec ❌ de 3 secondes lors d'un abandon/erreur/arrêt
- **Effets sonores 8 bits** — Carillon ascendant à la fin d'une tâche ; onde carrée descendante en cas d'échec. Les sons ne se jouent que pour les événements en direct (< 5 secondes au démarrage)
- **Sons d'échec** — Son distinct pour les événements `abort`, `session.error` et `session.shutdown`
- **Messages d'assistant concaténés** — La sortie de l'assistant dans le même tour est regroupée en un seul bloc de message lisible au lieu de nombreux fragments
- **Filtre de démarrage** — Au lancement, seule la tâche en cours (depuis le dernier `user.message`) est chargée pour éviter de rejouer l'historique complet de la session
- **Vérification des mises à jour** — Le panneau Paramètres inclut désormais une page « À propos » avec un bouton de vérification de version propulsé par Sparkle
- **Refonte des paramètres** — Mise en page plus claire, couleurs de bascule corrigées, utilisation appropriée des couleurs du thème

### Correctifs
- **Panneau aligné sur le bord supérieur de l'écran** — Le panneau de l'encoche développé démarre maintenant au niveau du bord physique de l'écran (aucun espace sous l'encoche)
- **Scintillement au démarrage éliminé** — La liste des sessions ne se re-rend plus des centaines de fois au démarrage ; le traitement par lots émet une seule mise à jour d'état
- **Timing du son corrigé** — Le son de fin se déclenche à `assistant.turn_end` après `session.task_complete`, et non prématurément lors de l'événement de tâche terminée lui-même
- **Mises à jour du chat en temps réel** — La vue détaillée de session interroge désormais les nouveaux messages toutes les secondes
- **Dimensions dynamiques de l'encoche** — La largeur et la hauteur du panneau sont calculées à partir des API d'écran macOS réelles (`auxiliaryTopLeftArea` / `auxiliaryTopRightArea`)
- **Barre d'encoche unifiée** — L'état fermé affiche une barre noire continue couvrant l'icône gauche, les points centraux et le compteur de sessions à droite
- **Audit des couleurs** — Correction des couleurs de texte d'espace réservé illisibles, des couleurs d'accentuation de bascule incohérentes et des tons bleus hors marque dans les paramètres

---

## v0.1.6 — 2026-04-02

### Correctifs
- Signer à nouveau les services XPC Sparkle avec le certificat Developer ID pour la conformité à la notarisation

---

## v0.1.5 — 2026-04-02

### Correctifs
- Récupérer le journal de rejet notarytool lorsque le statut de notarisation est `Invalid` pour faciliter le débogage

---

## v0.1.4 — 2026-04-02

### Correctifs
- Ajouter l'option `--timestamp` à `codesign` pour la conformité à la notarisation

---

## v0.1.3 — 2026-04-02

### Correctifs
- Rendre l'étape de notarisation non fatale afin que les versions GitHub se publient même si la notarisation retourne une erreur 401
- Ajouter des diagnostics de disponibilité des secrets au workflow de publication
- Corriger les vérifications conditionnelles dans le workflow de publication pour les étapes de signature

---

## v0.1.2 — 2026-04-02

*(Tagué avec v0.1.3 — voir les notes de v0.1.3)*

---

## v0.1.1 — 2026-04-01

### Fonctionnalités
- Signature Developer ID + workflow de notarisation dans GitHub Actions

### Correctifs
- `build_dmg.sh` utilise le certificat Apple Development en remplacement lorsque le Developer ID est indisponible
- Le DMG est maintenant créé en une seule étape `hdiutil` avec compression UDZO

---

## v0.1.0 — 2026-03-31

🎉 **Version initiale** de Copilot Island.

### Fonctionnalités
- Fenêtre superposée à l'encoche qui surveille `~/.copilot/session-state/` en temps réel
- Liste des sessions affichant toutes les sessions Copilot CLI actives et récentes
- Vue de l'historique des conversations avec rendu Markdown, blocs de code et résultats d'outils
- État « pastille » rétractée avec icône de statut gauche et compteur de sessions droit
- Développement/réduction au clic ou au survol de l'encoche
- Thème vert sauge sombre inspiré de Copilot
- Forme d'encoche à sommet plat au niveau du bord de l'écran, coins inférieurs arrondis
- Effet sonore à la tâche terminée par l'agent
- macOS 14.0+ (Sonoma), prise en charge de l'encoche MacBook
- Licence open source Apache 2.0
