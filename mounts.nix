
{...}:

############################
# Mount points/Filesystems #
############################

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c0f4dafc-5ba9-4a5f-9de2-20496daa3bec";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F303-7D87";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/99a4f49a-a8aa-4645-978b-ae469064c25e"; }
    ];

  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/4dd43a15-cfe2-4d6f-889e-aeb333cb8b04";
    fsType = "ext4";
    options = [ "defaults" ];
  };
}

