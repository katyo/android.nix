{ config, pkgs ? import <nixpkgs> {}
, pkgs_i686 ? import <nixpkgs> { system = "i686-linux"; }
, licenseAccepted ? config.android_sdk.accept_license or false
}:

rec {
  composeAndroidPackages = import ./compose-android-packages.nix {
    inherit (pkgs) requireFile autoPatchelfHook;
    inherit pkgs pkgs_i686 licenseAccepted;
  };

  buildApp = import ./build-app.nix {
    inherit (pkgs) stdenv lib jdk ant gnumake gawk;
    inherit composeAndroidPackages;
  };

  emulateApp = import ./emulate-app.nix {
    inherit (pkgs) stdenv lib;
    inherit composeAndroidPackages;
  };

  androidPkgs_4_1 = composeAndroidPackages {
    platformVersions = [ "16" ];
    abiVersions = [ "x86" "x86_64" "armeabi-v7a" "arm64-v8a" ];
    includeNDK = true;
  };

  androidPkgs_9_0 = composeAndroidPackages {
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64"];
  };
}
