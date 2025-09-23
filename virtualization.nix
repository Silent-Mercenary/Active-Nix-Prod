{... }:

{
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2"; # Change to "btrfs" if on btrfs
    daemon.settings = {
      userland-proxy = false;
      experimental = true;
    };
  };
}

# Docs 
# Docker ---> https://nixos.wiki/wiki/Docker
