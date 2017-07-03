INSTALL	= sudo install
REBUILD	= sudo nixos-rebuild switch
TARGET	= /etc/nixos/configuration.nix
SOURCE	= configuration.nix

all: $(TARGET)
	$(REBUILD)

$(TARGET): $(SOURCE)
	$(INSTALL) $(SOURCE) $(TARGET)
