{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Replaced 'driSupport32Bit'
  };
  environment = {
    systemPackages = with pkgs; [
      	libva
      	mesa
	libvdpau-va-gl
	libva-vdpau-driver
	libva-utils
    ];
   };
}
