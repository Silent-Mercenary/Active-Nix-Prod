# jellyfin.nix
{ pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "admin";
  };



  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}