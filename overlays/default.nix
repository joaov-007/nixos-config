{ inputs, ... }:
{

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
