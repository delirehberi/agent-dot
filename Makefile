.PHONY: dev deploy sync status check help

help:
	@echo "Available targets:"
	@echo "  make dev     - Run syntax validation, secret/path leak checks, and status inspection"
	@echo "  make deploy  - Sync symlinks and render configuration templates to host locations"
	@echo "  make sync    - Alias for deploy"
	@echo "  make status  - Show active symlinks and repository git status"
	@echo "  make check   - Validate script syntax, JSON files, and template variables"

dev: check status

deploy:
	./manage.sh sync

sync: deploy

status:
	./manage.sh status

check:
	./manage.sh check
