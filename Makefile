.PHONY: all clean

datapack_files := $(shell find src/)

datapack_name := $(shell jq -r '.pack.description[0]?.text // .pack.description' src/pack.mcmeta)
package_filename := $(shell echo '$(datapack_name).zip' | sed 's/[A-Z]/\L&/g; s/\s\+/-/g')

# Check where to install the datapack. If Minecraft was installed with Flatpak
# then the Minecraft directory we want to install to will be in
# ~/.var/app/com.mojang.Minecraft/data/minecraft. Otherwise the target directory
# will usually be ~/.minecraft.
ifndef minecraft_directory
ifneq ($(wildcard ~/.var/app/com.mojang.Minecraft/data/minecraft/*),)
minecraft_directory := ~/.var/app/com.mojang.Minecraft/data/minecraft
else ifneq ($(wildcard ~/.minecraft/*),)
minecraft_directory := ~/.minecraft
endif
endif

ifndef minecraft_directory
$(error Could not find a minecraft directory in either ~/.var/app/com.mojang.Minecraft/data/minecraft or ~/.minecraft)
endif

datapacks_directory := $(minecraft_directory)/datapacks

.PHONY: all
all: $(package_filename)

.PHONY: install
install: $(package_filename) $(datapacks_directory)
	cp $(package_filename) $(datapacks_directory)

.PHONY: clean
clean:
	rm $(package_filename)

$(package_filename): $(datapack_files)
	cd src && zip -r ../$@ *

$(datapacks_directory):
	mkdir -p $(datapacks_directory)
