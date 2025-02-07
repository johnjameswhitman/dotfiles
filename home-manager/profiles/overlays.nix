self: super:
{
  # Jetbrains uses the old style derivations (this doesn't match new overrides
  # pattern you see in recent documentation). To get the sha256 without pre-
  # fetching the download, you can append `.sha256` to the end of the URL:
  # https://download.jetbrains.com/python/pycharm-professional-${name}.tar.gz.sha256
  jetbrains = super.jetbrains // {
    pycharm-professional-2020_3_3 = super.jetbrains.pycharm-professional.overrideDerivation (old: rec {
      name = "pycharm-professional-${version}";
      version = "2020.3.3";
      src = super.fetchurl {
        url = "https://download.jetbrains.com/python/${name}.tar.gz";
        sha256 = "b526c73554a297b509565f0c218bce64f4f63072766d2ca9d4fb1a7efb0dfbfb";
      };
    });

    pycharm-professional-2020_3_4 = super.jetbrains.pycharm-professional.overrideDerivation (old: rec {
      name = "pycharm-professional-${version}";
      version = "2020.3.4";
      src = super.fetchurl {
        url = "https://download.jetbrains.com/python/${name}.tar.gz";
        sha256 = "2060539f9c4c42819a58a7bcae1143d6383507907acd1cc4d1f05d2c0a93f3a1";
      };
    });

    pycharm-professional-2020_3_5 = super.jetbrains.pycharm-professional.overrideDerivation (old: rec {
      name = "pycharm-professional-${version}";
      version = "2020.3.5";
      src = super.fetchurl {
        url = "https://download.jetbrains.com/python/${name}.tar.gz";
        sha256 = "d30b78b7deb680a1a9f6a36ca09ab1ed602eb8cb760f6f8083780ba3cd46b8e3";
      };
    });

    pycharm-professional-2021_1 = super.jetbrains.pycharm-professional.overrideDerivation (old: rec {
      name = "pycharm-professional-${version}";
      version = "2021.1";
      src = super.fetchurl {
        url = "https://download.jetbrains.com/python/${name}.tar.gz";
        sha256 = "bf86f3b316191e9d7e2e96d4fa055c095c59202f6af287103f54fde75b256bd8";
      };
    });

    pycharm-professional-2021_1_1 = super.jetbrains.pycharm-professional.overrideDerivation (old: rec {
      name = "pycharm-professional-${version}";
      version = "2021.1.1";
      src = super.fetchurl {
        url = "https://download.jetbrains.com/python/${name}.tar.gz";
        sha256 = "afdbb1f8b63f927b871dd11600e3eb71a739d60f471dc7f4a9752a1aed918971";
      };
    });

  };

  # Pidgin requires you to specify which plugins you want.
  pidgin-with-plugins = super.pidgin.override {
    plugins = [
      super.purple-googlechat
    ];
  };
}
