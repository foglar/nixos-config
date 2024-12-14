{
  pkgs-stable,
  username,
  ...
}: {
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  imports = [
    ../nixos/packages/packages.nix
    ../nixos/desktop/gnome/gnome.nix
  ];

  desktop.gnome.enable = true;

  group = {
    hacking.enable = false;
    applications.enable = false;
    terminal_tools.enable = true;
    programming.enable = false;
  };

  program = {
    kitty.enable = false;
    tmux.enable = false;
    zoxide.enable = false;
    vscode.enable = false;
    git.enable = false;
    neovim.enable = false;
    firefox.enable = false;
    spotify.enable = false;
  };

  sh.bash = {
    enable = true;
    oh-my-posh.enable = false;
  };

  programs = {
    bat.enable = false;
    btop.enable = false;
    fzf.enable = false;
  };

  home.packages = with pkgs-stable; [
    libreoffice
    inkscape
    gimp
    firefox
    distrobox
  ];

  programs.home-manager.enable = true;
}
