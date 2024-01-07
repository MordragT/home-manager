{pkgs, ...}: {
  home.packages = with pkgs; [
    calls # phone dialer and call handler
    denaro # personal finance manager
    endeavour # task manager
    foliate # book reader
    rnote # draw notes
    paperwork
    pdfarranger
    valent # kde connect implementation for gnome
  ];
}
