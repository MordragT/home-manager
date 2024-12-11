{
  buildPythonPackage,
  python,
  fetchwheel,
  autoPatchelfHook,
  zlib,
  level-zero,
  intel-dpcpp,
}:
buildPythonPackage rec {
  pname = "pytorch_triton_xpu";
  version = "3.0.0";
  format = "wheel";

  src = fetchwheel {
    base = "https://download.pytorch.org/";
    dist = "whl/nightly";
    abi = "%2B1b2f15840e";
    package = "${pname}-${version}";
    sha256 = "sha256-hwFG6wzEiaSam7mAh6xl30XF+TENGOadY5mgSIEY7D4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    intel-dpcpp.llvm
  ];

  # for 3.2.0
  #   postFixup = ''
  #     substituteInPlace $out/${python.sitePackages}/triton/backends/intel/driver.py \
  #       --replace-fail 'ze_root = os.getenv("ZE_PATH", default="/usr/local")' \
  #       'ze_root = os.getenv("ZE_PATH", default="${level-zero}")'
  #   '';

  postFixup = ''
    substituteInPlace $out/${python.sitePackages}/triton/backends/intel/driver.py \
      --replace-fail 'dirname = os.getenv("ZE_PATH", default="/usr/local")' \
      'dirname = os.getenv("ZE_PATH", default="${level-zero}")'
  '';
}
