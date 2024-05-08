{pkgs, ...}: {
  home.packages = with pkgs; [
    # matlab
    # spotify # spotube is far better # listen to music
    unigine-superposition

    # Social
    discord
    # xwaylandvideobridge # needed to fix discord video streaming
    teamspeak_client
    # broken teams-for-linux # microsoft teams
    zoom-us
    webex
    # whatsapp-for-linux
  ];
}
