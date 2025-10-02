{config, pkgs, ...}:
{
systemd.services.noip = {
  enable = true;
  description = "noip DUC for NixOS";
  after = [ "network-online.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    User = "root";
    Restart = "on-failure";
    RestartSec = 300;
    ExecStart = "${pkgs.noip}/bin/noip2";
    EnvironmentFile = "/etc/nixos/secrets/no-ip.env";
  };
};
}
