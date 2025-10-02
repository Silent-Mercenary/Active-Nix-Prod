{pkgs, ...}:
# Security nix is responsible for SSH and fail2ban, firewalls configs are spread all around due to how services 
{

 
  security.doas ={ 
    enable = true;
  	extraRules = [
    {
      groups = [ "wheel" ];
      keepEnv = true;
      persist = true;
      noLog = true;
    }
  ];
 };



  services.openssh = {
    enable = true;  # enables ssh
    ports = [ 22 ]; # default port for ssh, scp, *remember to cuck ssh to tailscale on the firewall page*
      settings = {
    PasswordAuthentication = true; # disable this once keys are made and distributed
    AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ] # allows you to block anyone but specified users, in which case null allows all users
    UseDns = true; # uses dns to resolve names, in this case allows "ssh admin@the-powerEDGing-machine" even though i doubt anyone with a sane ming would type that out
    X11Forwarding = false; 
    # x11 forwarding is disabled due to not having a x11 server running, see https://wiki.nixos.org/wiki/Category:Desktop_environment/en for setting up DEs
    PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };  

  environment.etc."no-ip2.conf".text = ''
	email=###########
	password=##########
	update_interval=30
  '';
  systemd.services.noip ={
  	enable = true;
  	description = "noip DUC for NixOS";
  	after = ["network-online.target"];
  	wantedBy = ["multi-user.target"];
  	serviceConfig = {
  		User = "root";
  		Restart = "on-failure";
		RestartSec = "300";
  		ExecStart = "${pkgs.noip}/bin/noip2 -c /var/lib/noip2.conf";
  	};
  };
  services.fail2ban = {
    enable = true; # enabled f2b

  
    jails.sshd.settings = {
      enabled = true; # enables this specific jail
      port = "22"; # port filter
      filter = "sshd"; #filter type
      logpath = "/var/log/auth.log"; # logging
      maxretry = 5; # 5 attempts before triggering ban
      findtime = 600; # 5 minute checking period
      bantime = 86400;  # 24 hr ban
      };
    

    jails.nextcloud.settings = {
      enable = true;
      backend = "auto";
      port = "8080,80,443"; # port filter
      filter = "nextcloud"; #filter type
      protocol = "tcp";
      logpath ="/var/www/nextcloud/config/nextcloud.log"; # logging
      maxretry = 3; # 3 attempts before triggering ban
      findtime = 600; # 5 minute checking period
      bantime = 86400;  # 24 hr ban
     };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.etc = {
    "fail2ban/filter.d/nextcloud.conf".text = ''
      [Definition]
        _groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
        failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Two-factor challenge failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
        datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
        '';
  };# any configuration thats blunt, ends with a ";"
}
# Docs ---\/ 
# ssh -------> https://nixos.wiki/wiki/SSH
# fail2ban --> https://nixos.wiki/wiki/fail2ban 
