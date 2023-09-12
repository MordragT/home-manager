{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust Tools
    rustscan # modern portscanner
    # broken sn0int # semi automatic osint framework
    authoscope # scriptable network authentication cracker
    metadata-cleaner

    cutter
    cutterPlugins.jsdec
    cutterPlugins.rz-ghidra
    macchanger # change the network's mac address
    # tor-browser-bundle-bin
    step-cli # generate certificates
  ];
}
