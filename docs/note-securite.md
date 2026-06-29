# Note de sécurité — PFE Infrastructure

## 1. Risques identifiés

| Risque | Niveau | Description |
|--------|--------|-------------|
| Exposition des secrets | Élevé | Mots de passe en clair dans les fichiers |
| Accès non autorisé à la BDD | Élevé | MySQL accessible sans restriction |
| Mise à jour des images | Moyen | Images Docker potentiellement obsolètes |
| Exposition des ports | Moyen | Services accessibles depuis l'extérieur |

## 2. Mesures mises en place

### Gestion des secrets
- Les mots de passe sont stockés dans un fichier `.env`
- Le fichier `.env` est ajouté au `.gitignore` : il n'est jamais publié sur GitHub
- Un fichier `.env.example` documente les variables sans exposer les vraies valeurs
- Aucun secret n'apparaît en clair dans le code source

### Isolation réseau
- Les services communiquent via un réseau Docker interne `pfe-network`
- MySQL et WordPress ne sont pas exposés directement sur internet
- Seul le port 8080 de Nginx est accessible depuis l'extérieur
- Principe du moindre privilège : chaque service n'accède qu'à ce dont il a besoin

### Healthcheck
- MySQL dispose d'un healthcheck automatique
- WordPress ne démarre qu'après que MySQL soit healthy
- Docker Compose gère le redémarrage automatique (`restart: always`)

### Mots de passe
- Les mots de passe respectent une complexité minimale (majuscules, chiffres, caractères spéciaux)
- Un utilisateur MySQL dédié (`appuser`) est créé pour WordPress
- Le compte root MySQL n'est pas utilisé par l'application

## 3. Limites de la solution

- L'infrastructure tourne en HTTP (pas de HTTPS/TLS)
- Pas de système de sauvegarde automatique de la base de données
- Pas de limitation du nombre de tentatives de connexion
- Environnement de développement uniquement, pas production-ready

## 4. Pistes d'amélioration

- Ajouter un certificat SSL/TLS avec Let's Encrypt
- Mettre en place des sauvegardes automatiques MySQL
- Utiliser Docker Secrets pour la gestion des secrets en production
- Ajouter un WAF (Web Application Firewall)
- Mettre en place une supervision avec Prometheus/Grafana
