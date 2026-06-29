# Schéma d'architecture — PFE Infrastructure

## Vue globale
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
Composants
ComposantImage DockerRôlePortNginxnginx:alpineReverse proxy8080WordPresswordpress:latestApplication web80 (interne)MySQLmysql:8.0Base de données3306 (interne)
Flux de communication

L'utilisateur envoie une requête HTTP sur le port 8080
Nginx reçoit la requête et la redirige vers WordPress
WordPress traite la requête et interroge MySQL si besoin
MySQL retourne les données à WordPress
WordPress génère la page HTML
Nginx retourne la réponse à l'utilisateur

Mécanismes de sécurité

Réseau isolé : MySQL et WordPress ne sont pas accessibles depuis l'extérieur
Secrets : mots de passe dans fichier .env non versionné
Healthcheck : MySQL vérifié avant démarrage de WordPress
Restart automatique : tous les services redémarrent en cas de crash
