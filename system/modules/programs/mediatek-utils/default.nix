{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.mediatek-utils;
in {
  options.mordrag.programs.mediatek-utils = {
    enable = lib.mkEnableOption "Mediatek Utils";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # pyside broken: mtk-client
      scrcpy
      spflashtool
    ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb",ATTR{idVendor}=="0e8d", MODE="0660", GROUP="adbusers"
    '';
  };
}
