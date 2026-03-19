{
  description = "QMK dev environment for Lumberjack (ATmega328p)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in {
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          avrPkgs = pkgs.pkgsCross.avr;
        in {
          default = pkgs.mkShell {
            packages = [
              avrPkgs.buildPackages.gcc      # avr-gcc (avr-libc is in the sysroot)
              avrPkgs.buildPackages.binutils # avr-binutils
              pkgs.avrdude
              pkgs.qmk
              pkgs.gnumake
              pkgs.git
            ];

            shellHook = ''
              export QMK_HOME="$(pwd)/qmk"

              # keymaps/kohsuk/ を QMK のキーマップディレクトリにシンボリックリンク
              KEYMAP_SRC="$(pwd)/keymaps/kohsuk"
              KEYMAP_DST="$(pwd)/qmk/keyboards/peej/lumberjack/keymaps/kohsuk"
              if [ -d "$QMK_HOME" ] && [ ! -L "$KEYMAP_DST" ]; then
                ln -sfn "$KEYMAP_SRC" "$KEYMAP_DST"
                echo "Linked: keymaps/kohsuk -> qmk/keyboards/peej/lumberjack/keymaps/kohsuk"
              fi

              echo ""
              echo "Build : cd qmk && make peej/lumberjack:kohsuk"
              echo "Flash : avrdude -c usbasp -p atmega328p -U flash:w:peej_lumberjack_kohsuk.hex:i"
            '';
          };
        });
    };
}
