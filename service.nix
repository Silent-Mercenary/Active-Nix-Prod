{...}:
{
	powerManagement = {
        enable = true;
		powertop.enable = true;	# --> enables powertop autotuning
	};

	services.tailscale = { 
  	enable = true; # --> tailscale daemon 
		permitCertUid = "239";
	};

	services.thermald.enable = true;
}

# Docs
# powertop --------> https://nixos.wiki/wiki/Laptop#Powertop
# powermanagement -> https://nixos.wiki/wiki/Power_Management
# jellyfin --------> https://wiki.nixos.org/wiki/Jellyfin
# tailscale -------> https://nixos.wiki/wiki/Tailscale