# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./caddy.nix
      ./fish.nix
      ./jellyfin.nix
      ./nix.nix
      ./mounts.nix
      ./piracy-suite.nix
      ./pkgs.nix
      ./qbittorrent.nix
      ./security.nix
      ./service.nix
      ./virtualization.nix
      

      
    ];

  # Todo ---> Fucking smt, idk im as confused as you are rn, P.S aiden wrote this


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-server"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  # User Account Management
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" "www-data" "jellyfin" ];
    shell = pkgs.fish;
  };
  users.groups.www-data = {
    gid = 33;
  };
  users.users.www-data = {
    isSystemUser = true;
    description = "www-data";
    group = "www-data";
    uid = 33;
    extraGroups = [ "networkmanager" ];
    shell = "${pkgs.shadow}/bin/nologin";
  };

  system.stateVersion = "25.05"; # this is the version that nixos thinks its part of, or in other words, change this to 25.11 if you wanna go with unstable

}
