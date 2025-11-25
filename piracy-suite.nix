{ pkgs, ... }:

let
  arrUser = "arr";
  arrGroup = "arr";
  baseDataDir = "/arr";
  services = [
    { name = "sonarr"; exe = "Sonarr"; pkg = pkgs.sonarr; port = 8989; }
    { name = "radarr"; exe = "Radarr"; pkg = pkgs.radarr; port = 7878; }
    { name = "lidarr"; exe = "Lidarr"; pkg = pkgs.lidarr; port = 8686; }
    { name = "readarr"; exe = "Readarr"; pkg = pkgs.readarr; port = 8787; }
    { name = "prowlarr"; exe = "Prowlarr"; pkg = pkgs.prowlarr; port = 9696; }
  ];
in
{
  users.users.arr = {
    isSystemUser = true;
    description = "Dedicated user for *arr services";
    group = arrGroup;
    extraGroups = [ "jellyfin" ];
    createHome = false;
    home = "/arr";
    shell = "${pkgs.fish}/bin/fish";
  };

  users.groups.arr = {};

  environment.systemPackages = map (s: s.pkg) services;

  system.activationScripts.arrDirs = {
    text = ''
      for dir in ${builtins.concatStringsSep " " (map (s: "${baseDataDir}/${s.name}") services)}; do
        mkdir -p "$dir"
      done
      chown -R ${arrUser}:${arrGroup} ${baseDataDir}
    '';
  };

  systemd.services = builtins.listToAttrs (map (s: {
    name = s.name;
    value = {
      description = "${s.name} - Arr service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        User = arrUser;
        Group = "jellyfin";
        ExecStart = "${s.pkg}/bin/${s.exe} -nobrowser -data=${baseDataDir}/${s.name}";
        Restart = "always";
        RestartSec = 10;
        WorkingDirectory = "${baseDataDir}/${s.name}";
        StandardOutput = "journal";
        StandardError = "journal";
      };
      wantedBy = [ "multi-user.target" ];
    };
  }) services);

  networking.firewall.allowedTCPPorts = map (s: s.port) services;
}

