# Nix package manager, settings
{pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.nix_2_30;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      log-lines = 50;
      http-connections = 25;
      max-jobs = "auto"; # Settings to auto/0 automatically lets the system figure shit out 
      cores = 0; # Threads allocated to 
      build-cores = 0; # Threads allocated to rebuild
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
  # Caching for nixos
      # Where tf to pull binaries from?
      substituters = [
        "https://cache.nixos.org/"
      ];
      # Keys for Transfering said binaries 
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  # Garbage Collection (cleans up symlinks and unused files from /nix/store)
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Let Nix install unfree packages
  nixpkgs.config = { 
    allowUnfree = true; # allows proprietary shit such as firmware (necessary for WLAN0!!!)
    nvidia.acceptLicense = true; # tell nvidia to suck a dick at compile time
  };

  # Enable firmware blob fetching
  hardware.enableAllFirmware = true; # Enables all proprietary blobs
}


