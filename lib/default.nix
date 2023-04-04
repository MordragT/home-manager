{ nixpkgs, pkgs, home-manager, agenix }:
{
  mkHost =
    { system
    , stateVersion
    , modules
    , specialArgs ? { }
    , specialHomeArgs ? { }
    , users
    , homes
    }:
    let
      config = pkgs.config;
      lib = pkgs.lib;
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        {
          boot.supportedFilesystems = [ "ntfs" ];

          inherit users;
          system.stateVersion = stateVersion;

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          boot.tmpOnTmpfs = true;
          boot.runSize = "50%";
          boot.kernelPackages = pkgs.linuxPackages_latest;
          # league of legends
          boot.kernel.sysctl."abi.vsyscall32" = 0;

          environment.sessionVariables = {
            XDG_CONFIG_HOME = "\${HOME}/.config";
            # not working ? XDG_CACHE_HOME = "\${XDG_RUNTIME_DIR}/.cache";
            XDG_CACHE_HOME = "/run/user/1000/.cache";
            XDG_DATA_HOME = "\${HOME}/.local/share";
            XDG_STATE_HOME = "\${HOME}/.local/state";
            XDG_BIN_HOME = "\${HOME}/.local/bin";
          };

          hardware.opengl.enable = true;
          hardware.opengl.mesaPackage = pkgs.mesa;
        }
        home-manager.nixosModules.home-manager
        {
          # maybe ? https://github.com/nix-community/home-manager/issues/2701
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialHomeArgs;
          home-manager.users = homes;
        }
        agenix.nixosModules.age
      ] ++ modules;

      # config._modules.args = { inherit pkgs; };
    };

  mkHome =
    { username
    , homeDirectory ? "/home/${username}"
    , stateVersion
    , imports
    }:
    {
      "${username}" = {
        inherit imports;

        home = {
          inherit username stateVersion homeDirectory;
        };
        xdg = {
          enable = true;
          userDirs.enable = true;
        };
      };
    };
}
