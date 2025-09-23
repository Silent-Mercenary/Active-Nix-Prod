{ config, pkgs, ... }:

{

 services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      libglvnd
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
  	];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    videoAcceleration = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
  };
    environment.systemPackages = with pkgs; [
    glxinfo
    vulkan-tools
    mesa-demos
    cudatoolkit
    nvidia-container-toolkit
  ];
}
