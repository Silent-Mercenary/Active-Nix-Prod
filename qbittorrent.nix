{pkgs, lib, ...}:

let
  arrUser = "arr";
  arrGroup = "arr";
  baseDataDir = "/arr";
  vpnNs = "vpnns";
  hostIf = "vpn-host";
  nsIf = "vpn-ns";
  hostIP = "10.200.200.1";
  nsIP = "10.200.200.2";
  nsSubnet = "10.200.200.0/30";
in
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;
    user = arrUser;
    group = arrGroup;
    profileDir = "${baseDataDir}/qbittorrent";
    # Web UI port
    webuiPort = 9091;

    # Persistent directories
    serverConfig = {
      Application = {
        FileLogger = {Age=1;AgeType=1;Backup=true;DeleteOld=true;Enabled=true;MaxSizeBytes=66560;
        Path="/arr/qbittorrent/qBittorrent/data/logs";};
      };
      BitTorrent = {
        Session = {
          AddTorrentStopped=false;
          AlternativeGlobalDLSpeedLimit=2500;
          AlternativeGlobalUPSpeedLimit=500;
          BandwidthSchedulerEnabled=true;
          DefaultSavePath="/arr/qbittorrent-download";
          ExcludedFileNames="*.scr, *.iso, *.html";
          GlobalDLSpeedLimit=5000;
          GlobalMaxSeedingMinutes=1440;
          GlobalUPSpeedLimit=1000;
          IgnoreSlowTorrentsForQueueing=true;
          Port=16622;
          QueueingSystemEnabled=true;
          SSL.Port = 10481;
          ShareLimitAction="Stop";
          TempPath="/arr/qbittorrent-incomplete";
          TempPathEnabled=true;
        };
      };
      Core.AutoDeleteAddedTorrentFile="IfAdded";
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          AuthSubnetWhitelist="192.168.2.0/24, 100.110.110.0/24";
          AuthSubnetWhitelistEnabled = true;
          Username = "admin";
          Port = 9091;
          Password_PBKDF2 = "@ByteArray(OSlRLvugJB7sj0xMpmC8HQ==:92YA84+fsMmJ64SUzCJ3ImPWR8gRzkqsNDBM5lda1MceohZGOhG1olc+hZCgPK+9laXSB8DyLnk3cjpHX5OMSQ==)";
          TrustedReverseProxiesList="192.168.2.25,127.0.0.1,100.110.110.253";
        };
        General.Locale = "en";
      };

    };

    # Make sure legal notice is auto-confirmed
    extraArgs = [ "--confirm-legal-notice" ];

    # Firewall
    openFirewall = true;
};

systemd.services.qbittorrent = lib.mkForce {
  description = "qBittorrent via PIA VPN namespace";
  after = [ "network-online.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "simple";
    # Run as root during setup
    User = "root";
    Group = "root";
    Restart = "always";
    RestartSec = 10;
    WorkingDirectory = "/arr/qbittorrent";

    Environment = ["HOME=/arr/qbittorrent"
    "PATH=${pkgs.iproute2}/bin:${pkgs.iptables}/bin:${pkgs.openvpn}/bin:/run/current-system/sw/bin"
    ];

  ExecStartPre = [
  (pkgs.writeShellScript "qbittorrent-vpn-prestart" ''
    set -eux
    mkdir -p /var/run/netns

    ip netns del ${vpnNs} 2>/dev/null || true
    ip link del ${hostIf} 2>/dev/null || true

    ip netns add ${vpnNs}
    ip link add ${hostIf} type veth peer name ${nsIf}
    ip link set ${nsIf} netns ${vpnNs}

    ip addr add ${hostIP}/30 dev ${hostIf}
    ip link set ${hostIf} up

    ip netns exec ${vpnNs} ip addr add ${nsIP}/30 dev ${nsIf}
    ip netns exec ${vpnNs} ip link set ${nsIf} up
    ip netns exec ${vpnNs} ip link set lo up

    # 🧠 Key additions below:
    # Enable forwarding on host
    sysctl -w net.ipv4.ip_forward=1

    # NAT traffic from namespace subnet
    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${nsSubnet} -o wlp65s0 -j MASQUERADE || true

    # Set default route inside namespace
    ip netns exec ${vpnNs} ip route add default via ${hostIP}
  '')
  ];

    ExecStart = (pkgs.writeShellScript "qbittorrent-vpn-start" ''
      set -eux

      # Start VPN in the namespace
      ip netns exec ${vpnNs} \
        ${pkgs.openvpn}/bin/openvpn --config /etc/nixos/secrets/mexico-pia.ovpn --daemon --writepid /run/openvpn-pia.pid

      # Wait for tun0
      for i in $(seq 1 20); do
        ip netns exec ${vpnNs} ip a show dev tun0 >/dev/null 2>&1 && break
        sleep 1
      done

      # Enable NAT
      ip netns exec ${vpnNs} ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE || true
      ip netns exec ${vpnNs} ip route add default dev tun0 || true

      # Drop privileges before starting qBittorrent
      exec ip netns exec ${vpnNs} \
        sudo -u ${arrUser} \
        ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox \
          --webui-port=9091 \
          --profile=${baseDataDir}/qbittorrent \
          --confirm-legal-notice
    '');

    ExecStopPost = [
      (pkgs.writeShellScript "qbittorrent-vpn-cleanup" ''
        ip netns del ${vpnNs} 2>/dev/null || true
        ip link del ${hostIf} 2>/dev/null || true
      '')
    ];
  };
};

}

