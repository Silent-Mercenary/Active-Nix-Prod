# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./ddclient.nix
    ./amd.nix
    ./caddy.nix
    ./docker.nix
    ./fish.nix
    ./jellyfin.nix
    ./nix.nix
    ./networking.nix
    ./piracy-suite.nix
    ./pkgs.nix
    ./qbittorrent.nix
    ./security.nix
    ./service.nix
    ./user.nix
    ./shm.nix
    ## To do: add git init hook
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05"; # this is the version that nixos thinks its part of, or in other words, change this to 25.11 if you wanna go with unstable
}
