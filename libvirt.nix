{config, pkgs, ...}:
{
    virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = false;
      ovmf.enable = true;
    };
  };
}
