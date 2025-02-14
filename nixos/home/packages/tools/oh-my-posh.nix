{
  lib,
  config,
  pkgs,
  userSettings,
  ...
}: {
  options = {
    sh.oh-my-posh.enable = lib.mkEnableOption "enable oh-my-posh";
    sh.bash.oh-my-posh.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable oh-my-posh for bash";
    };
    sh.zsh.oh-my-posh.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable oh-my-posh for zsh";
    };
  };

  config = lib.mkIf config.sh.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration =
        if config.sh.bash.enable == true
        then true
        else false;
      enableZshIntegration =
        if config.sh.zsh.enable == true
        then true
        else false;
      settings = {
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
        "blocks" = [
          {
            "alignment" = "left";
            "segments" = [
              {
                "type" = "session";
                "foreground" = "lightBlue";
                "foreground_templates" = [
                  "{{ if .Root }}lightRed{{ end }}"
                ];
                "properties" = {
                  "display_host" = true;
                };
                "style" = "plain";
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>┌──(</>{{ .UserName }}{{ if .Root }}💀{{ else }}󱄅 {{ end }}{{ .HostName }}<{{ if .Root }}lightBlue{{ else }}green{{ end }}>)</>";
              }
              {
                "type" = "nix-shell";
                "style" = "powerline";
                "foreground" = "blue";
                "background" = "transparent";
                "template" = "{{if eq .Type \"impure\" }}[󱄅 nix-shell]{{ end }}";
              }
              {
                "type" = "text";
                "style" = "plain";
                "foreground" = "yellow";
                "template" = "{{ if .Env.CONTAINER_ID }}-[󰡨 {{ .Env.CONTAINER_ID }}]-{{ end }}";
              }
              {
                "type" = "python";
                "foreground" = "yellow";
                "properties" = {
                  "fetch_version" = true;
                  "fetch_virtual_env" = true;
                  "display_default" = false;
                  "display_mode" = "files";
                };
                "style" = "plain";
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>-[</> {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }}{{ end }}<{{ if .Root }}lightBlue{{ else }}green{{ end }}>]</>";
              }
              {
                "type" = "go";
                "style" = "powerline";
                "powerline_symbol" = "";
                "foreground" = "#7FD5EA";
                "display_mode" = "files";
                "fetch_version" = false;
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>-[</> {{ if .Error }}{{ .Error }}{{ else }}OS:{{if eq .Env.GOOS \"linux\"}}󰌽{{else if eq .Env.GOOS \"windows\"}}{{else}}{{.Env.GOOS}}{{end}} ARCH:{{.Env.GOARCH}}{{ end }}<{{ if .Root }}lightBlue{{ else }}green{{ end }}>]</>";
              }
              {
                "type" = "path";
                "foreground" = "lightWhite";
                "properties" = {
                  "folder_separator_icon" = "<#c0c0c0>/</>";
                  "style" = "full";
                };
                "style" = "plain";
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>-[</>{{if eq .Folder \"${userSettings.username}\"}}~{{else}}{{ .Folder }}{{end}}<{{ if .Root }}lightBlue{{ else }}green{{ end }}>]</>";
              }
              {
                "type" = "git";
                "foreground" = "white";
                "style" = "plain";
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>-[</>{{ .HEAD }}<{{ if .Root }}lightBlue{{ else }}green{{ end }}>]</>";
              }
            ];
            "type" = "prompt";
          }
          {
            "alignment" = "right";
            "segment" = [
              {
                "type" = "executiontime";
                "foreground" = "white";
                "properties" = {
                  "always_enabled" = true;
                  "style" = "round";
                };
                "style" = "plain";
                "template" = " {{ .FormattedMs }} ";
              }
              {
                "type" = "status";
                "foreground" = "green";
                "foreground_templates" = [
                  "{{ if gt .Code 0 }}red{{ end }}"
                ];
                "properties" = {
                  "always_enabled" = true;
                };
                "style" = "plain";
                "template" = " {{ if gt .Code 0 }}{{.Code}}{{else}}\ueab2{{ end }} ";
              }
            ];
            "type" = "prompt";
          }
          {
            "alignment" = "left";
            "newline" = true;
            "segments" = [
              {
                "type" = "text";
                "foreground" = "lightBlue";
                "style" = "plain";
                "template" = "<{{ if .Root }}lightBlue{{ else }}green{{ end }}>└─</>{{ if .Root }}<lightRed>#</>{{ else }}\${{ end }} ";
              }
            ];
            "type" = "prompt";
          }
        ];
        "version" = 2;
      };
      #useTheme = "catppuccin_mocha";
      useTheme = "kali";
    };

    home.packages = with pkgs; [
      oh-my-posh
    ];
  };
}
