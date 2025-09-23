{pkgs, ...}:

let
  arrUser = "arr";
  arrGroup = "arr";
  baseDataDir = "/arr";
in
{
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
}
