{ pkgs, ... }: {
  imports = [
    ./art.nix
    ./audio.nix
    ./development.nix
    ./documents.nix
    ./gaming.nix
    ./gnome.nix
    ./nix.nix
    ./programs
    ./security.nix
    ./social.nix
    ./tools.nix
    ./video.nix
  ];
}
