{
  inputs,
  pkgs,
  userSettings,
  ...
}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;

    extraSpecialArgs = {inherit inputs userSettings;};
  };

  terminal.font = "${pkgs.terminus-nerdfont}share/fonts/truetype/NerdFonts/Terminess/TerminessNerdFont-Regular.ttf";

  # Simply install just the packages
  #environment.packages = with pkgs; [
  # Some common stuff that people expect to have
  #procps
  #killall
  #diffutils
  #findutils
  #utillinux
  #tzdata
  #hostname
  #man
  #gnugrep
  #gnupg
  #gnused
  #gnutar
  #bzip2
  #gzip
  #xz
  #zip
  #unzip
  #];

  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";
}
