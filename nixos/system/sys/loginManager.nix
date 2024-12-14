{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    sys.login.sddm.enable = lib.mkEnableOption "Enable SDDM login";
    sys.login.gdm.enable = lib.mkEnableOption "Enable GDM login";
  };

  config = lib.mkMerge [
    (lib.mkIf config.sys.login.sddm.enable {
      services.displayManager = {
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
          theme = "sddm-astronaut-theme";
          package = lib.mkDefault pkgs.kdePackages.sddm;
          extraPackages = [pkgs.sddm-astronaut pkgs.kdePackages.qtvirtualkeyboard];
        };
      };

      environment.systemPackages = with pkgs; [
        (sddm-astronaut.override {
          themeConfig = {
            ScreenWidth = 1920;
            ScreenHeight = 1080;
            PartialBlur = false;
          };
        })
      ];
    })
    (lib.mkIf config.sys.login.gdm.enable {
      services.xserver.displayManager.gdm.enable = true;
    })
  ];
}