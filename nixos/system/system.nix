{lib, ...}: {
  imports = [
    ./sys/audio.nix
    ./sys/desktops.nix
    ./sys/fonts.nix
    ./sys/locales.nix
    ./sys/network.nix
    ./sys/nvidia.nix
    ./sys/printing.nix
    ./sys/loginManager.nix
    ./sys/style.nix
  ];

  sys = {
    audio.enable = lib.mkDefault true;
    desktop = {
      plasma.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault false;
      hyprland.enable = lib.mkDefault true;
    };
    fonts.packages = lib.mkDefault true;
    locales.enable = lib.mkDefault true;
    network.enable = lib.mkDefault true;
    bluetooth = {
      enable = lib.mkDefault true;
      blueman.enable = lib.mkDefault true;
    };
    nvidia.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    login = {
      sddm.enable = lib.mkDefault true;
      gdm.enable = lib.mkDefault false;
    };
    style.enable = lib.mkDefault true;
  };
}
