{ pkgs, ...}:
{
    # Allow Proprietary Packages to run
  nixpkgs.config.allowUnfree = true;

  # System wide packages using the prefix "pkgs."
  environment.systemPackages = with pkgs; [
  git curl wget micro fish zellij btop
  micro zoxide fwupd noip nixpkgs-fmt caddy 
  tailscale jq openvpn nil
  ];
}
