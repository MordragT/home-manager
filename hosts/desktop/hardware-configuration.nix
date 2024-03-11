# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "btintel"];
  # boot.kernelParams = [
  #   "i915.force_probe=!56a1"
  #   "xe.force_probe=56a1"
  # ];
  boot.extraModulePackages = [];

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
  # a traditional swapfile I should be gucci
  zramSwap = {
    enable = true;
    writebackDevice = "/dev/disk/by-label/SwapWriteback";
  };
}
