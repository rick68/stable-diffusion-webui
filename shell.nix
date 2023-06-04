{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      MPISupport = true;
    };
  }
}:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    torch
    torchvision
    numba
  ]);

in
pkgs.mkShell rec {
  packages = with pkgs; [
    python3
    pythonEnv
    autoPatchelfHook
    gcc-unwrapped.lib
    git
    gcc-unwrapped.lib
    zlib
    libGL.out
    glib.out
  ] ++ (with xorg; [
    libSM
    libICE
  ]);
  shellHook = ''
  '';
}
