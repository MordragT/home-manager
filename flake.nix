{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    js-bp = {
      url = "github:serokell/nix-npm-buildpackage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comoji = {
      url = "github:MordragT/comoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hua = {
      url = "github:MordragT/hua";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templates.url = "github:MordragT/nix-templates";
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , home-manager
    , nix-alien
    , fenix
    , js-bp
    , gomod2nix
    , agenix
    , comoji
    , hua
    , templates
    }@inputs:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nix-alien.overlays.default
          nur.overlay
          agenix.overlays.default
          comoji.overlays.default
          # hua.overlay
          fenix.overlays.default
          js-bp.overlays.default
          gomod2nix.overlays.default
          (import ./overlay.nix)
        ];
      };
      lib = import ./lib { inherit nixpkgs pkgs home-manager agenix; };
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        tom-laptop = lib.mkHost rec {
          inherit system;
          stateVersion = "22.11";
          modules = [
            {
              imports = [
                ./hosts/laptop
                ./system
              ];
            }
          ];

          users = {
            users.root = {
              extraGroups = [ "root" ];
            };

            users.tom = {
              isNormalUser = true;
              extraGroups = [ "wheel" "docker" ];
              shell = pkgs.nushell;
            };
          };

          specialArgs = {
            inherit pkgs;
          };

          specialHomeArgs = {
            inherit templates;
          };

          homes =
            (lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [ ./home ];
            }) //
            (lib.mkHome {
              inherit stateVersion;
              username = "root";
              homeDirectory = "/root";
              imports = [
                ./home/programs/nushell.nix
              ];
            });
        };

        tom-lenovo = lib.mkHost rec {
          inherit system;
          stateVersion = "22.11";
          modules = [
            {
              imports = [
                ./hosts/lenovo
                ./system
              ];
            }
          ];

          users = {
            users.root = {
              extraGroups = [ "root" ];
            };

            users.tom = {
              isNormalUser = true;
              extraGroups = [ "wheel" "docker" "vboxusers" ];
              shell = pkgs.nushell;
            };
          };

          specialArgs = {
            inherit pkgs;
          };

          specialHomeArgs = {
            inherit templates;
          };

          homes =
            (lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [ ./home ];
            }) //
            (lib.mkHome {
              inherit stateVersion;
              username = "root";
              homeDirectory = "/root";
              imports = [
                ./home/programs/nushell.nix
              ];
            });
        };

        tom-pc = lib.mkHost rec {
          inherit system;
          stateVersion = "22.11";
          modules = [
            {
              imports = [
                ./hosts/desktop
                ./system
              ];
            }
          ];

          users = {
            users.root = {
              extraGroups = [ "root" ];
            };

            users.tom = {
              isNormalUser = true;
              extraGroups = [ "wheel" "docker" "vboxusers" ];
              shell = pkgs.nushell;
            };
          };

          specialArgs = {
            inherit pkgs;
          };

          specialHomeArgs = {
            inherit templates;
          };

          homes =
            (lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [ ./home ];
            }) //
            (lib.mkHome {
              inherit stateVersion;
              username = "root";
              homeDirectory = "/root";
              imports = [
                ./home/programs/nushell.nix
              ];
            });
        };
      };

      homeConfigurations = {
        tom = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit templates;
          };

          modules = [
            ({ ... }: {
              home.username = "tom";
              home.homeDirectory = "/home/tom";
              home.stateVersion = "22.11";
              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
            })
            ./home
          ];
        };
      };

      overlay = import ./overlay.nix;

      devShell."${system}" =
        let
          vscode-extensions = with pkgs; pkgs.writeShellScriptBin "vscode-ext" ''
            # Helper to just fail with a message and non-zero exit code.
            function fail() {
                echo "$1" >&2
                exit 1
            }

            # Helper to clean up after ourselves if we're killed by SIGINT.
            function clean_up() {
                TDIR="${TMPDIR:-/tmp}"
                echo "Script killed, cleaning up tmpdirs: $TDIR/vscode_exts_*" >&2
                rm -Rf "$TDIR/vscode_exts_*"
            }

            function get_vsixpkg() {
                N="$1.$2"

                # Create a tempdir for the extension download.
                EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)

                URL="https://$1.gallery.vsassets.io/_apis/public/gallery/publisher/$1/extension/$2/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"

                # Quietly but delicately curl down the file, blowing up at the first sign of trouble.
                ${curl}/bin/curl --silent --show-error --retry 3 --fail -X GET -o "$EXTTMP/$N.zip" "$URL"
                # Unpack the file we need to stdout then pull out the version
                VER=$(${jq}/bin/jq -r '.version' <(${unzip}/bin/unzip -qc "$EXTTMP/$N.zip" "extension/package.json"))
                # Calculate the SHA
                SHA=$(nix-hash --flat --base32 --type sha256 "$EXTTMP/$N.zip")

                # Clean up.
                rm -Rf "$EXTTMP"
                # I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

                cat <<-EOF
              {
                name = "$2";
                publisher = "$1";
                version = "$VER";
                sha256 = "$SHA";
              }
            EOF
            }

            # See if we can find our `code` binary somewhere.
            if [ $# -ne 0 ]; then
                CODE=$1
            else
                CODE=$(command -v code || command -v codium)
            fi

            if [ -z "$CODE" ]; then
                # Not much point continuing.
                fail "VSCode executable not found"
            fi

            # Try to be a good citizen and clean up after ourselves if we're killed.
            trap clean_up SIGINT

            # Begin the printing of the nix expression that will house the list of extensions.
            printf '{ extensions = [\n'

            # Note that we are only looking to update extensions that are already installed.
            for i in $($CODE --list-extensions)
            do
                OWNER=$(echo "$i" | cut -d. -f1)
                EXT=$(echo "$i" | cut -d. -f2)

                get_vsixpkg "$OWNER" "$EXT"
            done
            # Close off the nix expression.
            printf '];\n}'
          '';
        in
        pkgs.mkShell {
          buildInputs = [
            vscode-extensions
          ];
        };
    };
}
