{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      MPISupport = true;
    };
  }
, lib ? pkgs.lib
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
    libtensorflow
  ] ++ (with xorg; [
    libSM
    libICE
  ]);

  shellHook = ''
    export LD_PRELOAD=$LD_PRELOAD''${LD_PRELOAD:+' '}'${pkgs.gperftools}/lib/libtcmalloc.so'
    export LD_PRELOAD=$LD_PRELOAD''${LD_PRELOAD:+' '}'${pkgs.libGL.out}/lib/libGL.so'
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+':'}'${lib.makeLibraryPath (with pkgs; [ glib.out ])}'
  '';
}
