{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      fira-code
      jetbrains-mono
      roboto
      noto-fonts
      noto-fonts-emoji
      caladea # similar to microsoft cambria
      # needed for steam adwaita theme
      cantarell-fonts
      times-newer-roman
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fira Code" ];
      serif = [ "Noto Serif" ];
      sansSerif = [ "Fira Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
