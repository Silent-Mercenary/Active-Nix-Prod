{ ... }:

{
  services.ddclient = {
    enable = true;
    interval = "5min";
    protocol = "cloudflare";
    username = "token";
    passwordFile = "/etc/nixos/secrets/ddclient";
    domains = [
      "nc.nasbox.ca"
      "jf.nasbox.ca"
    ];
    zone = "nasbox.ca";
    ssl = true;
    verbose = true;
    use = "web, web=checkip.amazonaws.com";
  };
}
