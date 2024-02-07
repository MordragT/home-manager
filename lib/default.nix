{
  nixpkgs,
  pkgs,
  home-manager,
}: {
  mkHost = {
    system,
    stateVersion,
    modules,
    specialArgs ? {},
    specialHomeArgs ? {},
    homes,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules =
        [
          {
            boot.supportedFilesystems = ["ntfs"];

            system.stateVersion = stateVersion;

            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            boot.tmp.useTmpfs = true;
            boot.tmp.tmpfsSize = "75%";
            boot.tmp.cleanOnBoot = true;
            boot.runSize = "25%";
            boot.kernelPackages = pkgs.linuxPackages_6_7; #linuxPackages_latest/testing
            # league of legends
            # boot.kernel.sysctl."abi.vsyscall32" = 0;
            # cs 2
            # boot.kernel.sysctl."vm.max_map_count" = 16777216;
          }
          home-manager.nixosModules.home-manager
          {
            # maybe ? https://github.com/nix-community/home-manager/issues/2701
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialHomeArgs;
            home-manager.users = homes;
          }
        ]
        ++ modules;

      # config._modules.args = { inherit pkgs; };
    };

  mkHome = {
    username,
    homeDirectory ? "/home/${username}",
    stateVersion,
    imports,
  }: {
    "${username}" = {
      home = {
        inherit username stateVersion homeDirectory;
      };
      xdg = {
        enable = true;
        userDirs.enable = true;
        # configHome = "~/.config";
        # cacheHome = "/run/user/1000/.cache";
        # dataHome = "~/.local/share";
        # stateHome = "~/.local/state";
      };
      inherit imports;
    };
  };
}
