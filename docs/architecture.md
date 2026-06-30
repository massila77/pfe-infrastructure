# Schéma d'architecture — PFE Infrastructure

## Vue globale
````````````````````
┌─────────────────────────────────────────────────────┐
│                    UTILISATEUR                       │
│                   (Navigateur web)                   │
└──────────────────────┬──────────────────────────────┘
│ HTTP :8080
▼
┌─────────────────────────────────────────────────────┐
│                 DOCKER HOST (PC)                     │
│                                                      │
│  ┌─────────────────────────────────────────────┐    │
│  │          Réseau Docker : pfe-network         │    │
│  │                                             │    │
│  │   ┌──────────┐         ┌──────────────┐    │    │
│  │   │  NGINX   │────────▶│  WORDPRESS   │    │    │
│  │   │:8080→:80 │         │    :80       │    │    │
│  │   └──────────┘         └──────┬───────┘    │    │
│  │                               │            │    │
│  │                               ▼            │    │
│  │                        ┌──────────────┐    │    │
│  │                        │    MYSQL     │    │    │
│  │                        │   :3306      │    │    │
│  │                        └──────────────┘    │    │
│  │                                             │    │
│  └─────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────┘
``````

## Composants

| Composant | Image Docker | Rôle | Port exposé |
|-----------|-------------|------|-------------|
| **Nginx** | `nginx:alpine` | Reverse proxy — point d'entrée unique | 8080 (public) |
| **WordPress** | `wordpress:latest` | Application web CMS | 80 (interne uniquement) |
| **MySQL** | `mysql:8.0` | Base de données | 3306 (interne uniquement) |

## Flux de communication

1. L'utilisateur envoie une requête HTTP sur le port **8080**
2. **Nginx** reçoit la requête et la redirige vers WordPress sur le port 80
3. **WordPress** traite la requête et interroge MySQL si besoin
4. **MySQL** retourne les données à WordPress
5. **WordPress** génère la page HTML et la renvoie à Nginx
6. **Nginx** retourne la réponse finale à l'utilisateur

## Mécanismes de sécurité

| Mécanisme | Description |
|-----------|-------------|
| **Réseau isolé** | Un seul port exposé vers l'extérieur (8080) — MySQL et WordPress ne sont pas accessibles directement depuis internet |
| **Gestion des secrets** | Mots de passe stockés dans un fichier `.env` non versionné, absent du dépôt Git |
| **Moindre privilège** | Un utilisateur MySQL dédié (`appuser`) est créé pour WordPress — le compte root n'est pas utilisé par l'application |
| **Healthcheck** | MySQL est vérifié automatiquement avant le démarrage de WordPress (`depends_on: condition: service_healthy`) |
| **Restart automatique** | Tous les services redémarrent automatiquement en cas de crash (`restart: always`) |

## Limites et pistes d'amélioration

- **Segmentation réseau** : l'infrastructure utilise un réseau Docker unique (`pfe-network`). Une amélioration serait de séparer en deux réseaux : un réseau `frontend-network` entre Nginx et WordPress, et un réseau `backend-network` avec `internal: true` entre WordPress et MySQL
- **HTTPS** : l'infrastructure tourne en HTTP. L'ajout d'un certificat SSL/TLS (Let's Encrypt) serait nécessaire en production
- **Pare-feu applicatif** : aucun WAF (Web Application Firewall) n'est mis en place — envisageable avec ModSecurity ou Cloudflare