{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.printing;
in {
  options = {
    mordrag.printing = {
      enable = lib.mkEnableOption "Printing";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };

    # https://nixos.wiki/wiki/Printing
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    services.printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };

    services.system-config-printer.enable = true;
  };
}
