# vim: set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent:

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
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
    # Maybe fix xorg freezing, per http://www.thinkwiki.org/wiki/Category:W540
    #kernelParams = boot.kernelParams ++ [
    #  "i915.modeset=1"
    #  "nouveau.modeset=0"
    #  "rdblacklist=nouveau"
    #];
    #blacklistedKernelModules = boot.blacklistedKernelModules ++ [ "nouveau" ];
  };

  # Maybe fix xorg freezing (complete guess)
  # Seems to cause the following in dmesg:
  #   drm:gen8_irq_handler [i915]] *ERROR* Fault errors on pipe A
  hardware.opengl = {
    driSupport = false;
    enable = false;
  };

  # Avoids FS corruption on SSDs (http://github.com/NixOS/nixpkgs/issues/11276)
  powerManagement.scsiLinkPolicy = "max_performance";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";

  environment = {
    systemPackages = with pkgs; [
      vim
      gnumake
      git
      screen
      w3m
      acpi
      termite
      dunst
      libnotify
      ghc
      cabal-install
      stack
      nix-repl
      pkgconfig
      #chromium
      firefox
    ];
    variables = {
      BROWSER = "w3m";
    };
  };

  programs = {
    vim.defaultEditor = true;
    bash.enableCompletion = true;
    #chromium = {
    #  defaultSearchProviderSearchURL = "https://duckduckgo.com?q={searchTerms}";
    #  extensions = [
    #    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    #    "ogfcmafjalglgifnmanfmnieipoejdcf" # uMatrix
    #    "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    #  ];
    #};
  };

  networking = {
    usePredictableInterfaceNames = false;
    hostName = "rio";
    wireless = {
      enable = true;
      #interfaces = wifi_nics;
      userControlled = {
        enable = true;
        group = "network";
      };
    };
    dhcpcd = {
      enable = true;
      #allowInterfaces = wifi_nics;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      displayManager.slim.enable = true;
      windowManager.xmonad = {
        enable = true;
        extraPackages = haskellPackages: with haskellPackages; [
          xmonad-contrib
          xmonad-extras
          fdo-notify
          url
          pkgs.acpi
        ];
      };
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
    dbus.socketActivated = true;
    acpid = {
      enable = true;
      handlers = {
        "mute" = {
          event = "button/mute.*";
          action = "amixer -c 1 set Master toggle";
        };
        "volumedown" = {
          event = "button/volumedown.*";
          action = "amixer -c 1 set Master 20dB-";
        };
        "volumeup" = {
          event = "button/volumeup.*";
          action = "amixer -c 1 set Master 20dB+";
        };
      };
    };
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
          -fn Terminus \
          -lb '#000000' -nb '#000000' -cb '#000000' \
          -lf '#339966' \
          -nf '#993366' \
          -cf '#996633'
      '';
    };
  };


  #nixpkgs.config = {
  #  allowUnfree = true;
  #};

  sound = {
    enable = true;
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
