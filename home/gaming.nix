{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # steam-tui
    steamcmd
    steam-run
    sc-controller
    # steamcontroller
    # lutris
    bottles
    protonup
    protontricks
    vulkan-tools
    minecraft
    optifine
    gamescope
    mangohud
    # unigine-superposition # benchmark
    # geekbench # benchmark
  ];

}
