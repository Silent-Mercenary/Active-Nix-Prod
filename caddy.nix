{ ... }:

{

  services.tailscale = {
    enable = true; # --> tailscale daemon
    permitCertUid = "239"; # ---> permit caddy GID to fetch tailscale cert
  };

  services.caddy = {
    globalConfig = ''
        		servers {
          			protocols h1 h2
        		}
      	'';
    enable = true;
    /*
                virtualHosts."jellyfin.nasbox.ca".extraConfig = ''
                  #encode gzip
        			flush_interval -1
                  # Serve ACME challenges over HTTP
                  handle /.well-known/acme-challenge/* {
                      root * /var/lib/caddy/.local/share/caddy/acme
                      file_server
                  }

                  # Everything else proxies to Jellyfin
                  reverse_proxy /* localhost:8096
                '';
      virtualHosts."dawson.sytes.net" = {
        extraConfig = ''
                  encode gzip

                  reverse_proxy /jellyfin* localhost:8096
          		    reverse_proxy            localhost:8081
        '';
      };
    */
    virtualHosts."nc.nasbox.ca".extraConfig = ''
      reverse_proxy 127.0.0.1:8081
    '';
    virtualHosts."jf.nasbox.ca".extraConfig = ''
      reverse_proxy 127.0.0.1:8096 {
        flush_interval -1
        header_up Host {host}
        header_up X-Real-IP {remote_host}
        # These two are CRITICAL for the WebSocket (WS) drops you saw
        header_up Upgrade {>Upgrade}
        header_up Connection {>Connection}
      }
    '';
    /*
      virtualHosts."jf.nasbox.ca".extraConfig = ''
        	encode gzip
          reverse_proxy 127.0.0.1:8096 {
        	flush_interval -1
        	}
      '';
    */
    # Internal Tailscale domain, May require certs ------->

    virtualHosts."server-nix.tailfe1dd.ts.net" = {
      extraConfig = ''
        encode gzip
        redir /portainer /portainer/
        handle_path /portainer/* {

          reverse_proxy localhost:9000 {
            header_up Host localhost:9000
            header_up -Origin
            header_up -Referer
          }
        }
        reverse_proxy /sonarr*    localhost:8989
        reverse_proxy /radarr*    localhost:7878
        reverse_proxy /lidarr*    localhost:8686
        reverse_proxy /readarr*   localhost:8787
        reverse_proxy /prowlarr*  localhost:9696
        redir /editor /editor/
        basic_auth /editor/* {
        admin $2a$14$B5fJGD5l0CtM806MPomxy.QCTX/FtsyKGUZT7M7P91FRTSqNtHADC
        }
        # basic password, cause why not?
        handle_path /editor/* {


          reverse_proxy localhost:8443 {
            header_up Host localhost:8443
            header_up -Origin
            header_up -Referer
          }
        }

        redir /qbt /qbt/
        handle_path /qbt/* {

          reverse_proxy 10.200.200.2:9091 {
            header_up Host 10.200.200.2:9091
            header_up -Origin
            header_up -Referer
          }
        }
        reverse_proxy 172.19.0.2:5005
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
