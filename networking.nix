{ pkgs, nix, ... }:

{
  # Rip the-powerEDGING-machine
  networking = {
    hostName = "dell-server"; # Define your hostname.
    useDHCP = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
  services.dhcpcd.enable = false;
}
