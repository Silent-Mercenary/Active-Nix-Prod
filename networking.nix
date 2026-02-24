{pkgs, nix, ...}:

{
    # Rip the-powerEDGING-machine
  networking ={
    hostName = "dell-server"; # Define your hostname.
    networkmanager ={
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
  };
}