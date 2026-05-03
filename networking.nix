{ pkgs, nix, ... }:

{
  # Rip the-powerEDGING-machine
  networking = {
    hostName = "dell-server"; # Define your hostname.
    useDHCP = false; # nukes DHCPCD #!
	dhcpcd.enable = false; # #2
	wireless.iwd = {
		enable = true;
	};
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
#     dchp = "internal"; # #3
    };
  };

}
