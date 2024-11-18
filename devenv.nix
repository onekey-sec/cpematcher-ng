{ pkgs, lib, config, inputs, ... }:
let
  root-dir = config.devenv.root;
  default-python-version = "3.11";
in
{
  # https://devenv.sh/basics/
  env = {
    # These are defined in languages.python, we need to override them
    POETRY_VIRTUALENVS_IN_PROJECT = lib.mkForce "false";
    POETRY_VIRTUALENVS_PATH = lib.mkForce "${root-dir}/.venvs";
    POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON = lib.mkForce "true";
  };

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    just
    (buildEnv {
      name = "python";
      paths = [
        inputs.nixpkgs-python.packages.x86_64-linux."3.8"
        python39
        python310
        python311
        python312
        python313
      ];
      ignoreCollisions = true;
    })
  ];

  # https://devenv.sh/languages/

  # https://devenv.sh/scripts/
  scripts.run-python-version.exec = ''
    #!/usr/bin/env bash
    VERSION=$1
    shift
    COMMAND="$@"
    poetry env use $VERSION
    poetry run -- $COMMAND
  '';

  enterShell = ''
    poetry env use ${default-python-version}
    export PATH=$(poetry env info -p)/bin:$PATH
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    python -m pytest tests/
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    ruff = {
      enable = true;
      args = [ "--config" "${root-dir}/pyproject.toml" ];
    };
    ruff-format.enable = true;
    check-added-large-files.enable = true;
    trim-trailing-whitespace = {
      enable = true;
      excludes = [ ".*.md$" ];
    };
    end-of-file-fixer.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
