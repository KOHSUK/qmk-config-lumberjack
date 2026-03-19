# ビルド・フラッシュ手順

Lumberjack キーボードのファームウェアをビルドして書き込む手順。

---

## 前提条件

| 必要なもの | 用途 |
|-----------|------|
| Nix（または NixOS） | 再現可能なビルド環境 |
| direnv + nix-direnv | 自動環境切り替え（任意） |
| USB-C ケーブル（データ通信対応） | フラッシュ |

> Nix 未インストールの場合：
> ```sh
> curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
> ```

---

## 初回セットアップ

### 1. リポジトリをクローン

```sh
git clone --recursive https://github.com/KOHSUK/qmk-config-lumberjack.git
cd qmk-config-lumberjack
```

`--recursive` を忘れると `qmk/` サブモジュールが空になるので注意。

### 2. 開発環境を起動

```sh
direnv allow
# または
nix develop
```

起動時に以下が自動で行われる：

- avr-gcc / avrdude 等がシェルに追加される
- `keymaps/kohsuk/` → `qmk/keyboards/peej/lumberjack/keymaps/kohsuk` のシンボリックリンクが作成される

### 3. 確認

```sh
avr-gcc --version
# avr-gcc x.x.x (GCC) ... が表示されること
```

### 4. udev ルール設定（Linux・初回のみ）

USB-C 経由でのフラッシュに root 権限が不要になる。

```sh
echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", TAG+="uaccess"' \
  | sudo tee /etc/udev/rules.d/50-usbasp.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```

---

## ビルド

```sh
cd qmk
make peej/lumberjack:kohsuk
```

成功すると `qmk/peej_lumberjack_kohsuk.hex` が生成される。

> サイズ目安: 20〜28 KB（ATmega328p の上限 32 KB 以内）

---

## フラッシュ

### 1. ブートローダーへの入り方

USB-C を接続した状態で：

1. **BOOT ボタン（SW2）を押したまま保持**
2. **RESET ボタン（SW1）を押して離す**
3. **BOOT ボタン（SW2）を離す**

キーボードとして認識されなくなれば成功。

> BOOT ボタンは Column 3 と共有のため、押下中に同列キーが反応するが正常動作。

### 2. 書き込み

```sh
cd qmk
avrdude -c usbasp -p atmega328p -U flash:w:peej_lumberjack_kohsuk.hex:i
```

### 3. 再起動

フラッシュ完了後、**RESET ボタン（SW1）を単独で押す**。
新しいファームウェアで起動する。

---

## キーマップを変更してフラッシュする場合

```sh
# 1. キーマップを編集
$EDITOR keymaps/kohsuk/keymap.c

# 2. ビルド
cd qmk && make peej/lumberjack:kohsuk

# 3. BOOT + RESET でブートローダーに入る

# 4. フラッシュ
avrdude -c usbasp -p atmega328p -U flash:w:peej_lumberjack_kohsuk.hex:i
```

**編集後は `KEYMAP.md` も更新すること。**

---

## トラブルシューティング

### `Permission denied` / `cannot find USB device`

- udev ルールが設定されているか確認（「udev ルール設定」セクション参照）
- USB-C を抜いて再接続してから再試行

### `initialization failed, rc=-1`

- ブートローダーモードに入れていない → BOOT + RESET の手順を再試行
- USB-C ケーブルが充電専用でないか確認（データ通信対応が必要）

### `--recursive` を忘れた場合

```sh
git submodule update --init
```

### シンボリックリンクが張られていない

```sh
direnv reload
# または
nix develop
```
