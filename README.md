# PFE Infrastructure — Déploiement automatisé avec Docker Compose

![CI](https://github.com/massila77/pfe-infrastructure/actions/workflows/ci.yml/badge.svg)

## Présentation du projet

Ce projet met en place une infrastructure web automatisée et reproductible pour une PME.
Il s'inscrit dans une démarche GitOps / Infrastructure as Code (IaC).

L'infrastructure déploie automatiquement trois services :
- **Nginx** : reverse proxy qui reçoit les requêtes des utilisateurs
- **WordPress** : application web (CMS)
- **MySQL** : base de données

## Architecture
![Architecture](docs/architecture.png)
Internet
│
▼
[Nginx :8080]  ← reverse proxy
│
▼
[WordPress]    ← application web
│
▼
[MySQL]        ← base de données

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

Avec le Makefile :
```bash
make deploy
```

Ou manuellement :
```bash
cd docker
docker compose --env-file ../.env up -d
```

### 4. Accéder au site

Le site est accessible sur : **http://localhost:8080**

## Commandes disponibles

| Commande | Description |
|----------|-------------|
| `make deploy` | Lancer l'infrastructure |
| `make stop` | Arrêter l'infrastructure |
| `make restart` | Redémarrer l'infrastructure |
| `make validate` | Vérifier que tout fonctionne |
| `make logs` | Afficher les logs |
| `make clean` | Supprimer tous les conteneurs |

## Procédure de validation

```bash
make validate
```

## Procédure de nettoyage

```bash
make clean
```

## CI/CD

Ce projet utilise **GitHub Actions** pour vérifier automatiquement à chaque push :
- La syntaxe du fichier docker-compose.yml
- La présence de tous les fichiers obligatoires
- Qu'aucun secret n'est exposé dans le dépôt

## Sécurité

- Les secrets sont stockés dans un fichier `.env` non versionné
- Le fichier `.env` est listé dans `.gitignore`
- Un fichier `.env.example` documente les variables sans exposer les valeurs
- Les services communiquent sur un réseau Docker isolé `pfe-network`
- Seul le port 8080 est exposé vers l'extérieur
- Principe du moindre privilège : un utilisateur MySQL dédié pour WordPress
- Healthcheck automatique sur MySQL

## Structure du projet
pfe-infrastructure/
├── .github/
│   └── workflows/
│       └── ci.yml          ← pipeline CI/CD
├── docker/
│   └── docker-compose.yml  ← configuration des services
├── config/
│   └── nginx.conf          ← configuration Nginx
├── scripts/
│   ├── deploy.sh           ← script de déploiement
│   └── validate.sh         ← script de validation
├── docs/
│   ├── architecture.md     ← schéma d'architecture
│   └── note-securite.md    ← note de sécurité
├── Makefile                ← raccourcis de commandes
├── .env.example            ← modèle des secrets
├── .gitignore              ← fichiers exclus de Git
└── README.md               ← documentation

## Auteur

Massila — ECE Paris — B3 AIS — 2026
