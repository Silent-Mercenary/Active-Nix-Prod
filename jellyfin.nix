# jellyfin.nix
{ pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
  };



  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
