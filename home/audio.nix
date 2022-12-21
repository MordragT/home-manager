{ pkgs }:
with pkgs; [
  # CLI
  alsa-utils # configure audio devices

  # GUI
  blanket # listen to chill sounds
  amberol # simple audio player
  mousai # identitfy any song
  easyeffects # audio effects
  helvum # patchbay for pipewire
  zrythm # music daw
  tenacity # master audio
  spotify # listen to music
]
