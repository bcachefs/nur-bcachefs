{ lib, buildPackages, fetchurl, perl, buildLinux, fetchpatch, kernelPatches, ...} @ args:

with lib;

let
  commit = "cdf89ca564aa1916f16a58a06a395bfb3a86d302";
  diffHash = "1b4114vbw4vk63h2rq6ldqbp5ynj3n9ymyimvx017n8ssdybsw5x";
  shorthash = lib.strings.substring 0 7 commit;
  kernelVersion = "5.13.19";
  oldPatches = kernelPatches;
    in
buildLinux (args // rec {
  version = "${kernelVersion}-bcachefs-unstable-${shorthash}";

  modDirVersion = "5.13.19";
  extraMeta.branch = versions.majorMinor kernelVersion;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${kernelVersion}.tar.xz";
      sha256 = "0yxbcd1k4l4cmdn0hzcck4s0yvhvq9fpwp120dv9cz4i9rrfqxz8";
    };
    kernelPatches = oldPatches ++ [ {
      name = "bcachefs-${commit}";
      patch = fetchpatch {
        name = "bcachefs-${commit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${commit}&id2=v${lib.versions.majorMinor kernelVersion}";
        sha256 = diffHash;
      };
      extraConfig = "BCACHEFS_FS m";
    } ];
} // (args.argsOverride or {  }))
