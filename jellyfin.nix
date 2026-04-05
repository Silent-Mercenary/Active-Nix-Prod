# jellyfin.nix
{ pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
  };
  users.users.jellyfin.extraGroups = [ "video" "render" ];
	systemd.services.jellyfin.environment = {
  		LIBVA_DRIVER_NAME = "radeonsi";
	};

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
