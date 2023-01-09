{ clangStdenv
, lib
, fetchFromGitHub
, llvm
, perl
, cmake
, clang
, bash
}:
clangStdenv.mkDerivation rec {
  pname = "byfl";
  version = "master";

  src = fetchFromGitHub {
    sha256 = "jGmhQwBwJ9oA8PsEL19iekZeaUjy4XWSMASvkfzRJBs=";
    rev = "9e6c255bf6044feb74b54ef97ef56df3d3b17e91";
    owner = "lanl";
    repo = "Byfl";
  };

  postPatch = ''
    substituteInPlace lib/byfl/gen_opcode2name \
      --replace "/bin/echo" "echo"

    substituteInPlace tools/wrappers/make-bf-mpi \
      --replace "#! /bin/bash" "#! ${bash}/bin/bash" \
      --replace "#! /bin/sh" "#! ${bash}/bin/bash"
  '';

  buildInputs = [
    llvm
    llvm.dev
    perl
    clang
  ];

  nativeBuildInputs = [ cmake ];
}
