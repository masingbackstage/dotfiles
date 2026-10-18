# dotfiles

Arch Linux + Hyprland (config w Lua).

## Struktura

- `config/` → kopiować do `~/.config/`
- `home/` → kopiować do `~/`

```bash
cp -r config/. ~/.config/
cp home/.zshrc home/.zshenv home/.gitconfig ~/
```

Po skopiowaniu:
- `~/.config/zed/settings.json` – wstawić własny token w miejsce `<TOKEN>`
- `~/.config/vdirsyncer/config` – wstawić login w miejsce `<LOGIN>` i utworzyć `~/.config/vdirsyncer/icloud-pass`
- `~/.config/hypr/hyprland.lua` – poprawić sekcję `hl.monitor` pod nowe ekrany
- nest-shell: `git clone https://github.com/masingbackstage/nest-shell ~/Projects/nest-shell` i `ln -s ~/Projects/nest-shell ~/.config/quickshell/nest-shell`
- oh-my-zsh + pluginy `zsh-autosuggestions`, `zsh-syntax-highlighting` (do `~/.oh-my-zsh/custom/plugins`)

## Najważniejsze apki

**Desktop:** hyprland, hypridle, hyprlock, hyprpolkitagent, hyprshot, hyprlauncher, quickshell (nest-shell), rofi, matugen, uwsm, xdg-desktop-portal-hyprland, cliphist, wl-clipboard, udiskie, network-manager-applet, pavucontrol, playerctl, gnome-keyring, ly

**Terminal:** ghostty, zsh + oh-my-zsh, starship, eza, fd, btop, fastfetch, yt-dlp

**Przeglądarki:** zen-browser-bin (główna), firefox, brave-bin, google-chrome

**Dev:** neovim, zed, visual-studio-code-bin, antigravity, claude-desktop, opencode, github-cli, docker + docker-compose, postgresql, postman-bin, termius, supabase-bin, ollama, nvm, pnpm, uv, go, rust, dotnet-sdk, godot

**Komunikacja:** discord / vesktop, signal-desktop, telegram-desktop, thunderbird

**Pliki:** thunar (+ archive-plugin, volman), ark, qbittorrent, filezilla, keepassxc, rclone

**Praca / twórczość:** obsidian, libreoffice-fresh, typst, texlive, gimp, blender, kicad, audacity, reaper, mixxx, vlc

**Kalendarz:** khal, vdirsyncer

**Gry:** steam, lutris, prismlauncher, gamemode, gamescope, wine, protontricks
