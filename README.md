# Kaze (風)

A lightweight anime streaming CLI for your terminal. Resolves streams directly into mpv with opening skip, binge mode, and audio track selection.

---

## Features

- **SmartSkip:** Auto-skips anime openings and recaps using AniSkip timestamps. Press `s` in the player to skip manually, or `e` to jump past ending credits without missing post-credit scenes.
- **Binge Mode (`n`):** Automatically plays the next episode once the current one reaches 85% progress.
- **Audio Toggle (`Tab`):** Quickly switch between English Subtitles (SUB) and English Dubbed (DUB).
- **Watch History:** Saves episode progress locally to `~/.kaze/history.json` and prompts you to resume.
- **Clean Terminal UI:** Built with Bubble Tea; runs mpv quietly in the background so your terminal never scrambles or leaks text.
- **In-App Self-Updater (`--update`):** Upgrade to the latest release in-place with a single command.
- **Trending Discovery (`Ctrl+T` / `--trending`):** Browse and stream top seasonal anime directly from AniList without leaving your terminal.
- **AniList Auto-Tracking (Optional · `kaze auth`):** Completely optional; no account or sign-up needed to browse and stream. If connected, automatically syncs watched episodes to your AniList profile at 85% progress and marks the series completed on the finale.

---

## Installation

### Windows
```powershell
irm https://github.com/yashh1321/kaze/releases/latest/download/install.ps1 | iex
```

### Linux & macOS
```bash
curl -fsSL https://raw.githubusercontent.com/yashh1321/kaze/main/install.sh | bash
```

### Prebuilt Binaries
You can also grab the standalone archive for your system directly from [Releases](https://github.com/yashh1321/kaze/releases/latest):
- **Windows (x64):** `kaze-windows-amd64.zip`
- **Linux (x64):** `kaze-linux-amd64.tar.gz`
- **macOS Apple Silicon (M1/M2/M3/M4):** `kaze-darwin-arm64.tar.gz`
- **macOS Intel (x64):** `kaze-darwin-amd64.tar.gz`

---

## Uninstallation

### Windows
```powershell
Remove-Item -Recurse -Force "$HOME\.kaze"
```

### Linux & macOS
```bash
rm -f /usr/local/bin/kaze ~/.local/bin/kaze && rm -rf ~/.kaze
```

---

## Requirements

Kaze requires **[mpv](https://mpv.io/)** in your PATH for video playback:

- **Windows:** `winget install mpv.net` (or `scoop install mpv`)
- **macOS:** `brew install mpv`
- **Linux:** `sudo apt install mpv` / `sudo pacman -S mpv` / `sudo dnf install mpv`

---

## Usage

```sh
# Open interactive search menu
kaze

# Search for a title directly
kaze "<title>"

# Search with English Dub filter enabled
kaze -dub "<title>"

# Play a specific episode directly
kaze -e 5 "<title>"

# Browse top trending anime from AniList
kaze --trending

# (Optional) Connect AniList account for automatic progress tracking
kaze auth

# Check status and active account
kaze status

# Disconnect AniList account
kaze logout

# Check for updates and update in-place
kaze --update

# Display installed version
kaze --version
```

---

## AniList Auto-Tracking (Optional)

Kaze can automatically update your watched episode counter on your AniList profile when you reach 85% of an episode (or advance via Binge Mode), and mark the series completed on the finale.

### Quick Setup:
1. Run in your terminal:
   ```sh
   kaze auth
   ```
2. Open the authorization URL shown in your terminal.
3. Click **Authorize** on AniList.
4. Copy the URL from your browser address bar (starts with `...#access_token=...`) and paste it into your terminal prompt.
   > **Note:** If AniList's background page displays `API route not found`, that is normal. AniList safely places your access token directly in your browser address bar. Kaze automatically extracts and verifies the token.

### Managing Your Account & Logging Out:
- **Check Status:** `kaze status` (shows connected AniList username).
- **Log Out:** `kaze logout` (wipes your token from `~/.kaze/config.json` and disables tracking while keeping your local history intact).
- **Revoke Online:** You can also revoke access anytime directly on AniList at `https://anilist.co/settings/apps`.

---

## Keybindings

### In the Menu
| Key | Action |
| :--- | :--- |
| `↑` / `↓` | Navigate titles and episodes |
| `Enter` | Select anime / Play episode |
| `Tab` | Switch between SUB and DUB audio |
| `Ctrl+T` | Toggle between Search and Trending anime |
| `s` / `Ctrl+S` | Toggle SmartSkip (auto-skip OP/recap) |
| `n` / `Ctrl+N` | Toggle Binge Mode (auto-play next episode) |
| `Ctrl+P` | Toggle Provider Mode (AUTO / MANUAL) |
| `Esc` | Back to search / Quit |

### In the Video Player (mpv)
| Key | Action |
| :--- | :--- |
| **`s`** | Skip opening theme or recap |
| **`e`** | Skip ending theme (credits) |
| `Space` | Pause / Resume |
| `←` / `→` | Seek backward / forward 5s |
| `Shift + ←` / `→` | Seek backward / forward 60s |
| `9` / `0` | Volume down / up |
| `q` | Close player and return cleanly to menu |

---

## Frequently Asked Questions (Q&A)

### Q: Does Auto-Skip skip endings too?
**A:** Auto-Skip only skips openings and recaps automatically. Endings are mapped to the **`e`** key instead. This is intentional: many anime have important post-credits scenes, cliffhangers, and next-episode previews. Auto-skipping the ending would cut those off. If you want to skip the ending credits, just tap **`e`** in the player to jump right to the post-credits scene.

### Q: How does Binge Mode work?
**A:** When Binge Mode is enabled (`n` toggle), Kaze monitors your playback position. When an episode reaches 85% progress, it marks the episode completed in your history and automatically loads the next episode when you exit or finish the video.

### Q: Where is my watch history saved?
**A:** Locally on your own computer in `~/.kaze/history.json`. Nothing is tracked or sent to any remote server. If you reopen an episode you previously started, Kaze will automatically resume from where you left off.

### Q: How does AniList Auto-Tracking work?
**A:** If you want your watched episodes to sync to your AniList profile, run `kaze auth` once. When you watch an episode past 85% progress (or advance via Binge Mode), Kaze automatically updates your AniList episode counter in the background, and marks the series completed on the finale. This is 100% optional—you can watch and stream completely anonymously without logging in.

### Q: How do I disconnect or remove my AniList account?
**A:** Run `kaze logout`. This immediately removes your access token from `~/.kaze/config.json` and disables tracking while leaving your local watch history (`history.json`) intact. You can also revoke access anytime from [AniList Authorized Apps](https://anilist.co/settings/apps).

### Q: Do I need Node.js, Python, or a browser installed?
**A:** No. Kaze is written in pure Go and compiles into a single native binary. It interacts directly over HTTP/HLS and connects to mpv via IPC. No Chrome, Puppeteer, or runtime environments needed.

### Q: Can I choose video quality?
**A:** Yes. By default, Kaze picks the highest available resolution (1080p). You can specify quality using the `-q` flag:
```sh
kaze -q 720p "<title>"
```

### Q: Why are some titles missing English dubs?
**A:** Not all series receive an English dubbed release. If a dub isn't available, press **`Tab`** to switch to SUB (Japanese audio with English subtitles), or press **`Ctrl+P`** to switch to `MANUAL` mode and select an alternative stream source.

---

## Troubleshooting

### `mpv` command not found
Kaze uses mpv as its video rendering engine. If mpv is missing from your system PATH, install it directly:
- **Windows:** `winget install mpv.net` (or `scoop install mpv`)
- **macOS:** `brew install mpv`
- **Linux:** `sudo apt install mpv` / `sudo pacman -S mpv` / `sudo dnf install mpv`

After installing, restart your terminal so the new PATH takes effect.

### Windows SmartScreen warning ("Windows protected your PC")
Because Kaze is a standalone precompiled binary distributed without a paid corporate Microsoft EV code-signing certificate, Windows SmartScreen may show an unknown publisher prompt on first launch. Click **More info** → **Run anyway**.

### Stream fails to load or times out
- Press **`Tab`** to toggle between SUB and DUB. Some stream sources only provide one audio track.
- Press **`Ctrl+P`** to switch from `AUTO` to `MANUAL` mode and select an alternative stream source.

### SmartSkip didn't trigger on an opening
Opening and recap markers are resolved via the community AniSkip database. Newly airing episodes or niche older series might not have timestamps submitted yet. Use **`s`** or `Shift+→` to seek forward manually.

### Terminal characters or cursor look misaligned
Legacy Windows Command Prompt (`conhost.exe`) lacks modern ANSI terminal escape code support. Use the modern **Windows Terminal** (standard on Windows 11, or install via `winget install Microsoft.WindowsTerminal`).

---

## Disclaimer

Kaze does not host, upload, or own any media files. It functions purely as a terminal frontend client interfacing with third-party community streams and media players. All media content and trademarks belong to their respective copyright owners.

---

## License

MIT
