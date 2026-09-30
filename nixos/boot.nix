{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  hardware.firmware = [
    (pkgs.runCommand "sceptre-q32-edid" {} ''
      mkdir -p $out/lib/firmware/edid
      echo "AP///////wBOFMYMAQAAACgdAQOARih4K911pVVOnScLUFQjCABhQIHAgYCpwHFA0cABAQEBal4AoKCgKVAwIDUAxI4hAAAeAAAA/QAwQRdjHgAKICAgICAgAjqAGHE4LUBYLEUADyghAAAeAAAA/ABTY2VwdHJlIFEzMgogASoCAyrxSxAfBRQEEwMSAhEBIwkHB4MBAABoAwwAEAAAeABoGgAAAQEwPACORICgcDgtQFgsRQBVKCEAAB5mIVCwUQAbMEBwNgAPKCEAAB5/IVaqUQAeMEaPMwBVKCEAAH/TLACkUTgtQCCgNQBVKCEAAHsAAAAAAAAAAAAAAAAASg==" \
      | base64 -d > $out/lib/firmware/edid/sceptre-q32.bin
    '')
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "hid_sony"
    "uinput"
  ];
  boot.kernelParams = [
    "amd_pstate=active"
    "drm.edid_firmware=HDMI-A-2:edid/sceptre-q32.bin"
  ];
}
