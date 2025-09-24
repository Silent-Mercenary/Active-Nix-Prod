{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Replaced 'driSupport32Bit'
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };
  environment = {
    systemPackages = with pkgs; [
      libva
      mesa
      lact
    ];
    variables = {
      ROC_ENABLE_PRE_VEGA = "1";
    };
  };
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
