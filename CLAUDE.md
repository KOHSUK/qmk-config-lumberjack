# CLAUDE.md

## プロジェクト概要

QMK firmware for Lumberjack keyboard (60 keys, 5x12, ATmega328p).
ZMK config (Ortholinix split, 48 keys) からのポート。

## 重要ルール

**キーマップを変更したら必ず `KEYMAP.md` も更新すること。**

変更対象:
- `keymaps/kohsuk/keymap.c` を編集した場合
  → `KEYMAP.md` の該当レイヤーのASCII図・凡例を同期する

## 主要ファイル

| ファイル | 用途 |
|---------|------|
| `keymaps/kohsuk/keymap.c` | キーマップ本体（8レイヤー） |
| `keymaps/kohsuk/config.h` | タッピング設定 |
| `KEYMAP.md` | キーマップリファレンス（人間が読む用） |
| `SETUP.md` | ビルド・フラッシュ手順 |
| `flake.nix` | Nix 開発環境 |

## ビルド・フラッシュ

```sh
cd qmk && make peej/lumberjack:kohsuk
avrdude -c usbasp -p atmega328p -U flash:w:peej_lumberjack_kohsuk.hex:i
```
