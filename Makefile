datapack_files := $(shell find src/)

datapack_name := $(shell jq -r '.pack.description[0]?.text // .pack.description' src/pack.mcmeta)
package := $(shell echo '$(datapack_name).zip' | sed 's/[A-Z]/\L&/g; s/\s\+/-/g')

.PHONY: all
all: $(package)

.PHONY: install
install: $(package) selected_world
	mkdir -p "$$(<selected_world)/datapacks"
	cp $(package) "$$(<selected_world)/datapacks"

.PHONY: uninstall
uninstall:
	rm "$$(<selected_world)/datapacks/$(package)"

.PHONY: clean
clean:
	rm $(package)

selected_world:
	nix run .#select_world

$(package): $(datapack_files)
	cd src && zip -r ../$@ *
