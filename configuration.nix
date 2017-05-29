# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# vim: set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent:

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  boot = {
    # Use the GRUB 2 boot loader.
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    # Use LUKS-encrypted LVM root 
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/sda3";
        preLVM = true;
      }
    ];
  };

  # Avoids FS corruption on SSDs (http://github.com/NixOS/nixpkgs/issues/11276)
  powerManagement.scsiLinkPolicy = "max_performance";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      screen
      w3m
      acpi
      gnumake
      termite
      dunst
      libnotify
      chromium
      ghc
      cabal-install
    ];
    variables = {
      BROWSER = "w3m";
    };
  };

  programs = {
    vim.defaultEditor = true;
    bash.enableCompletion = true;
  };

  networking = let wifi_nics = [ "wlp3s0" ]; in {
    hostName = "rio";
    wireless = {
      enable = true;
      interfaces = wifi_nics;
    };
    dhcpcd = {
      enable = true;
      allowInterfaces = wifi_nics;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      displayManager.slim.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
    dbus.socketActivated = true;
    #tlp.enable = true;
    #thinkfan.enable = true;
  };

  systemd.user.services = {
    "dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = ''
        ${pkgs.dunst}/bin/dunst \
	  -geometry x1 \
	  -lb '#000000' -nb '#000000' -cb '#000000' \
	  -lf '#339966' \
	  -nf '#993366' \
	  -cf '#996633'
      '';
    };
  };


  nixpkgs.config.allowUnfree = true;

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
    extraConfig = ''
      defaults.pcm.!card 1;
    '';
  };

  users.extraUsers.hamlinb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
  };

  virtualisation.xen = {
    enable = true;
    domain0MemorySize = 4096;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
