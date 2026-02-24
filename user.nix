{pkgs, ...}:
{
  # User Account Management
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" "www-data" "jellyfin" "libvirtd" ];
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
}