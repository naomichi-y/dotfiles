# dotfiles

## Required tools

* git
* zsh

## Installation

### Base

```zsh
# Edit
$ vi .env

$ ./setup.sh

# すべての確認をスキップして自動上書き
$ ./setup.sh -y
```

### iTerm2

#### Change font

1. Open `Preferences`-`Profiles`-`Text`tab from menu bar.
2. Specify `HackGen` in `Font`

#### Change color

1. Open `Preferences`-`General`tab from menu bar.
2. Set `etc/iTerm2/com.googlecode.iterm2.plist` to `Load preferences from a custom folder or URL`.
3. Open `Profiles`-`Colors` tab.
4. Specify `Color presets`-`Import` and set `etc/iTerm2/iceberg.itermcolors`.
