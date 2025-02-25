{
  lib,
  config,
  ...
}: {
  options = {
    sys.nvidia.enable = lib.mkEnableOption "Enable NVIDIA graphics support";

    sys.nvidia.mode = lib.mkOption {
      type = lib.types.enum ["offload" "sync" "reverse" "disable" "none"];
      default = "none";
      description = ''
        NVIDIA graphics mode.
      '';
    };
    sys.nvidia.optimus.offload = lib.mkEnableOption "Enable NVIDIA Prime graphics support";
    sys.nvidia.optimus.sync = lib.mkEnableOption "Enable NVIDIA Prime sync";
    sys.nvidia.optimus.reverse = lib.mkEnableOption "Enable NVIDIA Prime reverse sync";
    sys.nvidia.disable = lib.mkEnableOption "Disable NVIDIA graphics completely";
  };

  config = lib.mkMerge [
    (lib.mkIf config.sys.nvidia.enable {
      hardware = {
        graphics.enable = true;
      };

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;
        prime.amdgpuBusId = "pci@000:04:0";
        prime.nvidiaBusId = "pci@000:01:0";
        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    })
    (lib.mkIf config.sys.nvidia.optimus.offload {
      hardware.nvidia.prime.offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    })
    (lib.mkIf config.sys.nvidia.optimus.sync {
      hardware.nvidia.prime.sync.enable = true;
    })
    (lib.mkIf config.sys.nvidia.optimus.reverse {
      hardware.nvidia.prime = {
        reverseSync.enable = true;
        # Enable if using an external GPU
        allowExternalGpu = false;
      };
    })
    (lib.mkIf config.sys.nvidia.disable {
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
    })
  ];
}
