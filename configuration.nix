# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # https://gist.github.com/misuzu/80af74212ba76d03f6a7a6f2e8ae1620#gistcomment-3543140
  environment.etc."nix/channels/nixpkgs".source = inputs.nixpkgs.outPath;
  environment.etc."nix/channels/home-manager".source = inputs.home-manager.outPath;
  nix.nixPath = [ 
    "nixpkgs=/etc/nix/channels/nixpkgs"
    "home-manager=/etc/nix/channels/home-manager"
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      luks.devices."root" = {
        device = "/dev/disk/by-uuid/b3886ab1-422f-4368-8339-da51dac32127"; 
        preLVM = true;
        keyFile = "/keyfile.bin";
        allowDiscards = true;
      };
      secrets = {
        "keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
      };
    };
  };

  time.timeZone = "America/Buenos_Aires";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    #wireless.enable = true;
    hostName = "nix";
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "LatGrkCyr-8x16";
    keyMap = "dvorak-l";
  };

  services.xserver = {
    enable = true;
    layout = "us,us(intl)";
    xkbVariant = "dvorak-l";
    xkbOptions = "grp:win_space_toggle";
    desktopManager.gnome3.enable = true;
    displayManager.gdm.enable = true;
    libinput.enable = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  security = {
    doas = {
      enable = true;
      wheelNeedsPassword = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
    '';
    promptInit = ""; # otherwise it'll override the grml prompt
  };

  environment.variables = { EDITOR = "nvim"; };

  users.users.fch = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  fonts.fonts = with pkgs; [
    hasklig
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
  ];

  users.users.fch.packages = with pkgs; [
    axel
    doas
    tilix
    neovim
    pinentry
    pinentry_gtk2
    pinentry_gnome
    firefox chromium
    (pass.withExtensions (ext: with ext; [pass-audit pass-otp pass-import pass-update pass-tomb])) 
    pass
    liquidprompt
    tdesktop
    vscodium
    docker
    docker-compose 
    gnome3.gnome-tweaks
    poetry
    gitAndTools.gitflow
  ];

  environment.systemPackages = with pkgs; [
    zsh
    fzf
    fzf-zsh
    grml-zsh-config
    zsh-nix-shell
    zsh-autosuggestions
    nix-zsh-completions
    wget
    curl
    vim
    gnupg
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

