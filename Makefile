.ONESHELL:
SHELL		= bash

LN		= ln -sf
CP		= cp -rf
RM		= rm -rf

NIXOS_REBUILD	:= $(shell command -v nixos-rebuild)
PACKAGE_FILES	:= $(shell find packages -type f -name '*.nix')
PACKAGE_DIRS	:= $(shell find packages -type d | sort)

NIX_CFG		= config.nix
NIX_CFGDIR	= $(HOME)/.nixpkgs
NIX_CANARY	= $(patsubst %,$(NIX_CFGDIR)/%,$(NIX_CFGDIR) $(PACKAGE_FILES))

NIXOS_CFG	= configuration.nix
NIXOS_CFGDIR	= /etc/nixos
NIXOS_CANARY	= $(patsubst %,$(NIXOS_CFGDIR)/%,$(NIXOS_CFGDIR) $(PACKAGE_FILES))

.PHONY: all
all: nix $(if $(NIXOS_REBUILD),nixos,)

.PHONY: nix
nix: $(NIX_CANARY)

$(NIX_CANARY): $(PACKAGE_FILES) $(NIX_CFG)
	$(RM) $(NIX_CFGDIR)
	mkdir $(NIX_CFGDIR)
	for dir in $(PACKAGE_DIRS); do
		mkdir "$(NIX_CFGDIR)/$$dir"
	done
	for file in $(PACKAGE_FILES); do
		$(LN) "$(PWD)/$$file" "$(NIX_CFGDIR)/$$file"
	done
	$(LN) $(PWD)/$(NIX_CFG) $(NIX_CFGDIR)/$(NIX_CFG)

.PHONY: nixos
nixos: $(NIXOS_CANARY)

$(NIXOS_CANARY): $(NIXOS_TARGET)
	sudo $(RM) $(NIXOS_CFGDIR)/packages
	[[ ! -d $(NIXOS_CFGDIR) ]] && sudo mkdir $(NIXOS_CFGDIR)
	sudo $(CP) $(NIXOS_CFG) packages/ $(NIXOS_CFGDIR)/
	sudo nixos-rebuild switch
	systemctl --user daemon-reload
	systemctl --user restart dunst
