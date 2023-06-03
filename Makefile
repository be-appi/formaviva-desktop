# use the rest as arguments for targets
TARGET_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(TARGET_ARGS):;@:)

-include .env

run:
	pdm config python.use_venv true && \
	pdm install && pdm run -v appening

install:
	pdm install

compile: install
	pdm run pyinstaller --collect-all appening -n formaviva_desktop --onefile formaviva_desktop/main.py

run-bin: compile
	./dist/formaviva_desktop

system: compile
	cp ./dist/formaviva_desktop ~/.local/bin/formaviva_desktop
	mkdir -p ~/.local/share/formaviva_desktop
	cp formaviva_desktop.png ~/.local/share/formaviva_desktop/formaviva_desktop.png
	sed -i "s@~@$HOME@g" formaviva_desktop.desktop
	cp formaviva_desktop.desktop ~/.local/share/applications/


shell:
	eval $(pdm venv activate)

flatpak-build:
	flatpak-builder --force-clean build-dir org.atumm.formaviva_desktop.yml

flatpak-install: flatpak-build
	flatpak-builder --user --install --force-clean build-dir org.atumm.formaviva_desktop.yml

flatpak-run: flatpak-install
	flatpak run org.atumm.formaviva_desktop

