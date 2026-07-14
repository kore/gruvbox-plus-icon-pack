# Packages the committed "Gruvbox-Plus-Green" variant as an icon theme.
#
# The green tree is generated from Gruvbox-Plus-Dark by scripts/recolor-green and
# committed to the repo, so this derivation just installs it. The committed
# icon-theme.cache is valid as-is (it indexes icon names -> directories, and the
# variant keeps the source theme's exact layout), so no regeneration is needed.
#
# Reproducible flow (your fork):
#   git fetch upstream && git merge upstream/master   # pull upstream
#   python3 scripts/recolor-green                      # regenerate the variant
#   git add Gruvbox-Plus-Green && git commit && git tag vX.Y.Z && git push --tags
# then bump `version`/`hash` below.
#
# Build straight from the fork:
#   nix-build nix/gruvbox-plus-green.nix
# or wire it into a NixOS config via pkgs.callPackage (see README).

{ lib
, stdenvNoCC
, fetchFromGitHub
, # Override with `src = ./..;` to build from a local checkout instead of GitHub.
  src ? null
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruvbox-plus-green-icons";
  version = "0.1.0";

  src =
    if src != null then src
    else fetchFromGitHub {
      owner = "kore";
      repo = "gruvbox-plus-icon-pack";
      rev = "v${finalAttrs.version}"; # TODO: tag your release
      hash = lib.fakeHash; # TODO: replace with the real hash (nix will print it)
    };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Green $out/share/icons/Gruvbox-Plus-Green
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gruvbox Plus icons, near-neutral with green accents (fork variant)";
    homepage = "https://github.com/kore/gruvbox-plus-icon-pack";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
})
