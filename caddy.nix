{ ... }:

{
  services.resolved.enable = true;

  services.netbird = {
    enable = true; # --> netbird
  };

  services.caddy = {
    globalConfig = ''
        		servers {
          			protocols h1 h2
        		}
      	'';
    enable = true;
    virtualHosts."nc.nasbox.ca".extraConfig = ''
      reverse_proxy 127.0.0.1:8081
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
