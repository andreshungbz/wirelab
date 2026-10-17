{
  pkgs,
  lib,
  ...
}:
{
  # https://devenv.sh/packages/
  packages =
    with pkgs;
    [
      curl
      git
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      strace
    ];

  # https://devenv.sh/languages/
  languages = {
    go = {
      enable = true;
      delve.enable = true;
      lsp.enable = true;
    };

    python = {
      enable = true;
      venv = {
        enable = true;
        requirements = ''

        '';
      };
    };
  };

  # https://devenv.sh/scripts/
  scripts.version.exec = ''
    go version
    python --version
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    version

    mkdir -p .vscode
    SETTINGS_FILE=".vscode/settings.json"
    if [ ! -f "$SETTINGS_FILE" ]; then
      echo "{}" > "$SETTINGS_FILE"
    fi

    jq --arg venv "$DEVENV_STATE/venv/bin/python" \
       '. + {
         "python.defaultInterpreterPath": $venv,
         "python.analysis.extraPaths": ["${"$"}{workspaceFolder}/python/src"],
         "python.analysis.typeCheckingMode": "basic"
       }' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
  '';
}
