{...}: {
  specialisation.cosmic.configuration = {
    system.nixos.tags = ["cosmic"];

    # Desktop & Display Manager
    services.displayManager.cosmic-greeter.enable = true;
    mordrag.desktop.cosmic.enable = true;

    mordrag.programs.gnome-disks.enable = true;
    # mordrag.services.samba.enable = true;
  };
}
