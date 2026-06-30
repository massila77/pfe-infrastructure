.PHONY: deploy stop restart validate logs clean help

help:
	@echo "Commandes disponibles :"
	@echo "  make deploy    - Lancer l'infrastructure"
	@echo "  make stop      - Arrêter l'infrastructure"
	@echo "  make restart   - Redémarrer l'infrastructure"
	@echo "  make validate  - Vérifier que tout fonctionne"
	@echo "  make logs      - Afficher les logs"
	@echo "  make clean     - Supprimer tous les conteneurs et volumes"

deploy:
	@echo "Démarrage de l'infrastructure..."
	cd docker && docker compose --env-file ../.env up -d
	@echo "Infrastructure démarrée ! Accès : http://localhost:8080"

stop:
	@echo "Arrêt de l'infrastructure..."
	cd docker && docker compose down
	@echo "Infrastructure arrêtée."

restart:
	@echo "Redémarrage de l'infrastructure..."
	cd docker && docker compose down
	cd docker && docker compose --env-file ../.env up -d
	@echo "Infrastructure redémarrée !"

validate:
	@echo "Validation de l'infrastructure..."
	bash scripts/validate.sh

logs:
	@echo "Affichage des logs..."
	cd docker && docker compose logs --tail=50

clean:
	@echo "Suppression de tout..."
	cd docker && docker compose down -v
	@echo "Nettoyage terminé."