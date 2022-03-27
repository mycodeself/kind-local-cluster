.PHONY: bootstrap destroy install-all upgrade-all install delete upgrade

bootstrap: 
	@echo "==> Bootstraping cluster ..."
	@bash scripts/bootstrap.sh

destroy:
	@echo "==> Destroying cluster ..."
	@bash scripts/destroy.sh

install:
	@echo "==> Installing app $(app) ..."
	@bash scripts/manage_app.sh install $(app)

upgrade:
	@echo "==> Upgrading app $(app) ..."
	@bash scripts/manage_app.sh upgrade $(app)

delete:
	@echo "==> Deleting app $(app) ..."
	@bash scripts/manage_app.sh delete $(app)

install-all: 
	@echo "==> Installing all apps ..."
	@bash scripts/manage_all_apps.sh install

upgrade-all: 
	@echo "==> Upgrading all apps ..."
	@bash scripts/manage_all_apps.sh upgrade	

delete-all: 
	@echo "==> Deleting all apps ..."
	@bash scripts/manage_all_apps.sh delete