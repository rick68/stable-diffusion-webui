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
    keras
    tensorflow
  ]);

in
pkgs.mkShell rec {
  packages = with pkgs; [
    python3
    pythonEnv
    autoPatchelfHook
    git
    gcc-unwrapped.lib
    zlib
    libGL.out
    glib.out
    libtensorflow
  ] ++ (with xorg; [
    libSM
    libICE
  ]);
  shellHook = ''
  '';
}
