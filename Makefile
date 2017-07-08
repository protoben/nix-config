INSTALL	= sudo cp -r
REBUILD	= sudo nixos-rebuild switch
DESTDIR	= /etc/nixos
TARGETS = configuration.nix packages.nix packages
SOURCES	= configuration.nix packages.nix packages/*/*
CANARY	= /etc/nixos/configuration.nix

all: $(CANARY)

$(CANARY): $(SOURCES)
	$(INSTALL) $(TARGETS) $(DESTDIR)/
	$(REBUILD)
