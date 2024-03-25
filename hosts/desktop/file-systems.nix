{...}: {
  boot.supportedFilesystems = ["ntfs"];

  fileSystems."/" = {
    device = "/dev/disk/by-label/Nixos";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "none";
    neededForBoot = true;
    fsType = "tmpfs";
    options = ["defaults" "size=50%" "mode=755"];
  };

  fileSystems."/run/media/Media" = {
    device = "/dev/disk/by-label/Media";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=zstd"
      "autodefrag"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/Swap";
    }
  ];

  # according to this https://github.com/systemd/systemd/issues/16708
  # systemd will skip zram swaps when hibernating, so as long as i keep
  # a traditional swap I should be gucci
  zramSwap = {
    enable = true;
    writebackDevice = "/dev/disk/by-label/SwapWriteback";
  };
}
