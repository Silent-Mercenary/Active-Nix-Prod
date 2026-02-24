{ pkgs, config, ... }:

{
  networking.nftables.enable = true;
  virtualisation = {
    incus = {
      enable = true;
      clientPackage = config.virtualisation.incus.package.client;
      package = pkgs.incus;
      # Webui pkg + Enablement
      ui = {
        enable = true;
        package = pkgs.incus-ui-canonical;
      };
    };
  };
  networking.firewall = {
    allowedUDPPorts = [ 6443 ];
    allowedTCPPorts = [ 6443 ];
    trustedInterfaces = [ "incusbr0" ];
  };
  users.users.admin.extraGroups = [ "incus-admin" ];
}
