{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nuenv.url = "github:DeterminateSystems/nuenv";
  };

  outputs =
    { self
    , nixpkgs
    , systems
    , nuenv
    }:
    let
      mkPkgs = localSystem: import nixpkgs { inherit localSystem; overlays = [ nuenv.overlays.default ]; };
      eachSystem = callback: nixpkgs.lib.genAttrs (import systems) (system: callback (mkPkgs system));
    in
    {
      packages = eachSystem (pkgs: {
        select_world = pkgs.nuenv.writeShellApplication {
          name = "select_world";
          runtimeInputs = with pkgs; [ fzf ];
          text = builtins.readFile ./scripts/select_world.nu;
        };
      });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            findutils
            fzf
            dialog
            git
            gnumake
            gnused
            jq
            zip
          ];
        };
      });
    };
}
