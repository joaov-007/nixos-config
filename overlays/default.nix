{ inputs, ... }:
{

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nightly-packages = final: prev: {
    nightly = import inputs.nixpkgs-nightly {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
