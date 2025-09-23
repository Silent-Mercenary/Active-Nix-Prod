{...}:
  # Fish Shell configuration, (can be edited in ~/.config/fish/config.fish)
{
  programs.fish = {
  	enable = true;
  	shellAliases = {
  		snrs  = "sudo nixos-rebuild switch"; # --> rebuilds system references configuration.nix and flake.nix (if flakes are enabled, (they arent))
  		nano  = "micro"; # --> replaces nano with micro, note: copy and paste doesnt work, smt about kitty
  		cd    = "z"; # --> replaces CD with zoxide (smart CD)
			nextcloud		= "docker exec -it --user www-data nextcloud-apache bash -c \"cd /var/www/nextcloud && bash\"";
			nc-root = "docker exec -it nextcloud-apache bash -c \"cd /var/www/nextcloud && bash\"";
  	};
  };
}