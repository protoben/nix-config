# vim: set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.packageOverrides = (import ./packages.nix) lib;
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
      #"nixpkgs=/home/hamlinb/proj/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    useSandbox = true;
    autoOptimiseStore = true;
    trustedUsers = [ "root" "hamlinb" ];
  };

  boot = {
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
    kernelParams = [
      # The arch-wiki thinks this might fix the xorg freezes:
      # https://wiki.archlinux.org/index.php/intel_graphics#X_freeze.2Fcrash_with_intel_driver
      "intel_idle.max_cstate=1"
      "i915.enable_rc6=0"
    ];
    blacklistedKernelModules = [
      "uvcvideo" # Remove and reboot on the off chance that we ever want the webcam
    ];
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
      acpi
      chromium
      dunst
      firefox
      git
      gnumake
      libnotify
      mlterm
      nix-repl
      pkgconfig
      screen
      vim
      w3m
    ];
    variables = {
      BROWSER = "w3m";
    };
    shellAliases = {
      ssh = "TERM=xterm-256color ssh";
      ls = "ls --color=tty";
    };
  };

  programs = {
    vim.defaultEditor = true;
    bash = {
      enableCompletion = true;
      promptInit =
        let
          UBG = "\\[$(tput setaf 21)\\]";
          UFG = "\\[$(tput setaf 27)\\]";
          RBG = "\\[$(tput setaf 124)\\]";
          RFG = "\\[$(tput setaf 163)\\]";
        in ''
          if (( EUID == 0 )); then
            PS1='${RBG}[${RFG}\u${RBG}@${RFG}\h${RBG}:${RFG}\w${RBG}]\$\[$(tput sgr0)\] '
          else
            PS1='${UBG}[${UFG}\u${UBG}@${UFG}\h${UBG}:${UFG}\w${UBG}]\$\[$(tput sgr0)\] '
          fi
        '';
    };
    chromium = {
      defaultSearchProviderSearchURL = "https://duckduckgo.com?q={searchTerms}";
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "ogfcmafjalglgifnmanfmnieipoejdcf" # uMatrix
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      ];
    };
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
    dbus.socketActivated = true;
    nixosManual.showManual = true;
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
      xkbOptions = "terminate:ctrl_alt_bksp, caps:ctrl_modifier";
    };
    acpid = {
      enable = true;
      handlers =
        let
          amixer = "${pkgs.alsaUtils}/bin/amixer";
          backlight_dir = "/sys/class/backlight/intel_backlight";
        in {
          "mute" = {
            event = "button/mute.*";
            action = "${amixer} -c 1 set Master toggle";
          };
          "volumedown" = {
            event = "button/volumedown.*";
            action = "${amixer} -c 1 set Master 5dB-";
          };
          "volumeup" = {
            event = "button/volumeup.*";
            action = "${amixer} -c 1 set Master 5dB+";
          };
          "brightnessup" = {
            event = "video/brightnessup.*";
            action = ''
              next=$(( $(cat ${backlight_dir}/actual_brightness) + 100 ))
              max=$(cat ${backlight_dir}/max_brightness)
              tee /dev/tty5 > ${backlight_dir}/brightness <<< $(( next > max ? max : next ))
            '';
          };
          "brightnessdown" = {
            event = "video/brightnessdown.*";
            action = ''
              next=$(( $(cat ${backlight_dir}/actual_brightness) - 100 ))
              min=100
              tee /dev/tty5 > ${backlight_dir}/brightness <<< $(( next < min ? min : next ))
            '';
          };
      };
    };
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
          -cf '#996633' \
          -history_key 'ctrl+shift+p' \
          -key         'ctrl+shift+n'
      '';
    };
  };

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.!card 1;
    '';
  };

  users = {
    users = {
      "hamlinb" = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "network" ];
      };
    };
    groups = {
      "network" = {};
    };
  };

  virtualisation.xen = {
    enable = true;
    domain0MemorySize = 4096;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
