# qmk-config-lumberjack

[Lumberjack](https://github.com/peej/lumberjack-keyboard) keyboard (60 keys, 5×12, ATmega328p) 用 QMK ファームウェア。

ZMK config ([Ortholinix split](https://github.com/KOHSUK/zmk-config-ortholinix), 48 keys) からのポート。

---

## キーマップ

8レイヤー構成。詳細は [docs/KEYMAP.md](docs/KEYMAP.md) を参照。

| レイヤー | 起動 | 用途 |
|---------|------|------|
| BASE | — | QWERTY |
| FN1 | 右スペース ホールド | 数字・括弧 |
| FN2 | 左スペース ホールド | 記号 |
| FN3 | Enter ホールド | ナビゲーション |
| FN4 | Backspace ホールド | Ctrlショートカット |
| FN5 | MO キー ホールド | 左修飾キー |
| FN6 | 右スペース2 ホールド | 右修飾キー |
| FN7 | `=` ホールド | ファンクションキー |

## クローン・ビルド・フラッシュ

```sh
git clone --recursive https://github.com/KOHSUK/qmk-config-lumberjack.git
cd qmk-config-lumberjack
direnv allow        # または nix develop
cd qmk && make peej/lumberjack:kohsuk
avrdude -c usbasp -p atmega328p -U flash:w:peej_lumberjack_kohsuk.hex:i
```

詳細手順 → [docs/build-and-flash.md](docs/build-and-flash.md)

## ファイル構成

```
keymaps/kohsuk/   # キーマップ本体（編集はここ）
docs/             # ドキュメント
flake.nix         # Nix 開発環境（avr-gcc, avrdude, qmk）
qmk/              # git submodule (qmk/qmk_firmware)
```
