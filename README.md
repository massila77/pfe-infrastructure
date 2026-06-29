# PFE Infrastructure — Déploiement automatisé avec Docker Compose

## Présentation du projet

Ce projet met en place une infrastructure web automatisée et reproductible pour une PME.
Il s'inscrit dans une démarche GitOps / Infrastructure as Code (IaC).

L'infrastructure déploie automatiquement trois services :
- **Nginx** : reverse proxy qui reçoit les requêtes des utilisateurs
- **WordPress** : application web (CMS)
- **MySQL** : base de données

## Architecture
Internet
│
▼
[Nginx :8080]
│
▼
[WordPress]
│
▼
[MySQL]

## Prérequis

- Git
- Docker Desktop
- Docker Compose v2

## Procédure de déploiement

### 1. Cloner le dépôt

```bash
git clone https://github.com/massila77/pfe-infrastructure.git
cd pfe-infrastructure
```

### 2. Configurer les secrets

```bash
cp .env.example .env
```

Editer le fichier `.env` et remplir les valeurs :
MYSQL_ROOT_PASSWORD=VotreMotDePasse
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=VotreMotDePasse
WORDPRESS_DB_PASSWORD=VotreMotDePasse

### 3. Lancer le déploiement

```bash
cd docker
docker compose --env-file ../.env up -d
```

### 4. Accéder au site

Le site est accessible sur : **http://localhost:8080**

## Procédure de validation

```bash
bash scripts/validate.sh
```

## Procédure de nettoyage

Arrêter les conteneurs :

```bash
cd docker
docker compose down
```

Tout supprimer y compris les données :

```bash
docker compose down -v
```

## Sécurité

- Les secrets sont stockés dans un fichier `.env` non versionné
- Le fichier `.env` est listé dans `.gitignore`
- Un fichier `.env.example` documente les variables sans exposer les valeurs
- Les services communiquent sur un réseau Docker isolé `pfe-network`
- Seul le port 8080 est exposé vers l'extérieur
- Principe du moindre privilège : un utilisateur MySQL dédié pour WordPress

## Structure du projet
pfe-infrastructure/
├── docker/
│   └── docker-compose.yml
├── config/
│   └── nginx.conf
├── scripts/
│   ├── deploy.sh
│   └── validate.sh
├── docs/
│   ├── architecture.md
│   └── note-securite.md
├── .env.example
├── .gitignore
└── README.md

## Auteur

Massila — ECE Paris — B3 AIS — 2026
