{
  ...
}:
{
  boot.specialFileSystems."/dev/shm" = {
    fsType = "tmpfs";
    options = [
      "rw"
      "nosuid"
      "nodev"
      "size=8g"
    ];
  };
}
