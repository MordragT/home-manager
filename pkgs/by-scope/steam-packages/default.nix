self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  opengothic = callPackage ./opengothic.nix {};
  proton-cachyos-bin = callPackage ./proton-cachyos.nix {};
  proton-ge-bin = pkgs.proton-ge-bin;
  luxtorpeda = pkgs.luxtorpeda;
  steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs (old: {
    # Prepare the proper files for the steam compatibility toolchain
    postInstall =
      old.postInstall
      + ''
        cat > $out/bin/compatibilitytool.vdf << EOF
        "compatibilitytools"
        {
          "compat_tools"
          {
            "steamtinkerlaunch" // Internal name of this tool
            {
              "install_path" "."
              "display_name" "Steam Tinker Launch"

              "from_oslist"  "windows"
              "to_oslist"    "linux"
            }
          }
        }
        EOF

        cat > $out/bin/toolmanifest.vdf << EOF
        "manifest"
        {
          "commandline" "/steamtinkerlaunch run"
          "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
        }
        EOF
      '';
  });
}
