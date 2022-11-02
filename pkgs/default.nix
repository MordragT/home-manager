{ pkgs }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  self = rec {
    grass = callPackage ./grass { };
    lottieconv = callPackage ./lottieconv { };
    superview = callPackage ./superview { };
    astrofox = callPackage ./astrofox.nix { };
    spflashtool = callPackage ./spflashtool.nix { };
    webdesigner = callPackage ./webdesigner.nix { };
    webex = callPackage ./webex.nix { };
    focalboard = callPackage ./focalboard.nix { };
    gnome-shell-extension-fly-pie = callPackage ./gnome-extensions/fly-pie.nix { };
    webcamoid = pkgs.libsForQt5.callPackage ./webcamoid.nix { };
    oneapi = callPackage ./oneapi.nix { };
    likwid = callPackage ./likwid.nix { };
  };
in
self

