{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  airportsdata,
  interegular,
  cloudpickle,
  datasets,
  diskcache,
  jinja2,
  jsonschema,
  numpy,
  outlines-core,
  pycountry,
  pydantic,
  lark,
  nest-asyncio,
  referencing,
  requests,
  torch,
  transformers,
}:
buildPythonPackage rec {
  pname = "outlines";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hbg2U0YYw16PMrVPihx/WsqcQxvk3fIL10nm1Vrs4Lw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    airportsdata
    interegular
    cloudpickle
    datasets
    diskcache
    jinja2
    jsonschema
    outlines-core
    pydantic
    lark
    nest-asyncio
    numpy
    referencing
    requests
    torch
    transformers
    pycountry
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    python3 -c 'import outlines'
  '';

  meta = with lib; {
    description = "Structured text generation";
    homepage = "https://github.com/outlines-dev/outlines";
    license = licenses.asl20;
    maintainers = with maintainers; [lach];
  };
}
