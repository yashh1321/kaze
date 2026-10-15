<p align="center">
  <h1 align="center">kaze (風)</h1>
  <p align="center">Fast, lightweight anime streaming in your terminal with mpv.</p>
  <p align="center">
    <a href="https://github.com/yashh1323/kaze/releases/latest"><img src="https://img.shields.io/github/v/release/yashh1323/kaze?style=flat-square&color=00ADD8" alt="Release"></a>
    <a href="https://golang.org"><img src="https://img.shields.io/badge/Go-1.24-00ADD8?style=flat-square&logo=go" alt="Go Version"></a>
    <a href="https://github.com/yashh1323/kaze/stargazers"><img src="https://img.shields.io/github/stars/yashh1323/kaze?style=flat-square&color=FFD700" alt="Stars"></a>
    <a href="https://github.com/yashh1323/kaze/releases"><img src="https://img.shields.io/github/downloads/yashh1323/kaze/total?style=flat-square&color=brightgreen" alt="Downloads"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="License"></a>
  </p>
</p>

---

`kaze` is a standalone terminal anime client and aggregator written in Go. It queries multiple indexers concurrently, deduplicates streams, and pipes video straight into [mpv](https://mpv.io) with automated intro/outro skipping, local history tracking, and anime upscaling shaders.

No Python virtual environments, no node dependencies, no browser automation, and no shell script wrappers. Just a single static binary.

```bash
# Search and open interactive TUI
kaze "<title>"

# Directly play episode 1 with English dub
kaze -e 1 --dub "<title>"

# Browse trending titles
kaze --trending
```

---

## Why Kaze?

Traditional terminal streaming tools often come with platform and environment trade-offs:
- **Shell-based scripts** rely on chains of external utilities (`curl`, `grep`, `sed`, `fzf`, `ffmpeg`). Getting them to work smoothly on Windows typically requires WSL, Git Bash, or Cygwin, and stream drops often require restarting the entire command.
- **Python-based clients** require Python runtimes, pip dependencies, virtual environments, and slower cold-start times.

Kaze was built to solve these issues:
1. **Single binary (~11 MB)**: Cross-compiled native Go. Drop it anywhere in your `PATH` and run.
2. **Instant startup (<15ms)**: No interpreter startup overhead.
3. **Concurrent multi-source search**: Queries distributed indexers in parallel using non-blocking goroutines. Results stream in as they arrive.
4. **Automatic failover (`AUTO` mode)**: If a CDN server buffers, fails, or goes down mid-stream, Kaze transparently falls back to an alternate mirror.
5. **Native Windows support**: Uses Windows Named Pipes (`\\.\pipe\kaze-mpv-*`) for mpv IPC communication rather than Unix socket workarounds.
6. **SmartSkip built-in**: Pulls opening/ending timestamps from AniSkip so you can skip theme songs automatically or with a single keypress (`s`).

---

## Comparison

| Feature | kaze | Shell Scripts | Python CLI Tools |
|:---|:---:|:---:|:---:|
| **Language** | **Go (Native)** | POSIX Shell | Python |
| **Distribution** | **Single binary (~11 MB)** | Multi-file scripts | Package (pip/venv) |
| **Startup time** | **< 15ms** | ~400ms | ~1.5s - 2.0s |
| **Dependencies** | `mpv` | `curl, sed, grep, fzf, ffmpeg` | Python, pip, libraries |
| **Concurrent search** | **Yes (goroutines)** | No (sequential) | No |
| **Auto CDN failover** | **Yes** | Manual restart | None |
| **Intro/Outro skipping** | **Built-in (AniSkip)** | Requires external helper | None |
| **MPV hotkey IPC (`s`)** | **Built-in** | Requires external script | None |
| **History & auto-resume** | **Built-in (`~/.kaze/history.json`)** | Basic logger | Limited |
| **Windows support** | **Native (Named Pipes)** | Requires WSL / Git Bash | Moderate |

---

## Features

- **Concurrent Multi-Source Aggregator**: Queries mirror gateways simultaneously, merging duplicates into a single clean list.
- **SmartSkip**: Automatically skips anime openings and recaps, or press `s` inside mpv to jump past them manually.
- **Subtitles & Dual Audio**: Auto-selects English subtitles with fuzzy track detection. Toggle subtitles on or off in the TUI with `Shift+J` for both Japanese (`SUB`) and English (`DUB`) playback.
- **Anime Shaders & Upscaling Matrix**: Real-time stacked neural shaders for anime rendering. Freely combine any enhancer mode with any upscale resolution:
  - Retro Deblur (`Ctrl+1`): Cleans ringing and compression artifacts on 480p/720p classics.
  - Modern Sharp (`Ctrl+2`): Sharpens line art on modern digital releases.
  - Stacked 2K / 4K Modes (`Ctrl+3`–`Ctrl+6`): Combines line restoration with 2K (1440p) or 4K (2160p) texture upscaling.
  - Pure 2K / 4K (`Ctrl+7` / `Ctrl+8`): High-resolution enlargement without altering original art lines.
- **Watch History**: Remembers your playback position and episode progress. Pick up where you left off without searching.
- **Binge Mode (Auto-Next)**: Automatically starts the next episode when the current one finishes.
- **Dual TUI Modes**: Press `F2` or `Ctrl+P` in the TUI to toggle between unified auto-aggregated mode and manual provider selection.
- **AniList Sync**: Track your progress to your personal AniList account.
- **In-Place Updates**: Run `kaze --update` (or `kaze -u`) to automatically fetch, verify, and swap in the latest release binary without touching your terminal setup or configuration.

---

## Installation

### Prerequisites

Kaze requires **[mpv](https://mpv.io)** for video playback. Make sure `mpv` is available in your system `PATH`:

- **Windows**: `scoop install mpv` or `winget install mpv.net`
- **macOS**: `brew install mpv`
- **Linux**: `sudo apt install mpv` / `sudo pacman -S mpv`

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/yashh1323/kaze/main/install.ps1 | iex
```

### Linux / macOS (Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/yashh1323/kaze/main/install.sh | bash
```

### Go Install

```bash
go install github.com/yashh1323/kaze/cmd/kaze@latest
```

### Pre-built Binaries

Download standalone binaries for Windows (`amd64`), Linux (`amd64`), and macOS (`arm64`/`amd64`) directly from [GitHub Releases](https://github.com/yashh1323/kaze/releases/latest).

### Updating

To update your existing installation to the latest release in-place:

```bash
kaze --update
# or shorthand
kaze -u
```

Kaze queries the GitHub Releases API for newer version tags, fetches the prebuilt archive matching your operating system and architecture (`windows-amd64`, `linux-amd64`, `darwin-arm64`, etc.), verifies the archive stream, and swaps the binary directly on disk. On Windows, where the operating system locks running executables, it performs an atomic swap via temporary staging and renaming so the update succeeds without manual deletion.

---

## Usage

### Interactive TUI

Run `kaze` with a search term to launch the interactive terminal interface:

```bash
kaze "<title>"
kaze --dub "<title>"
kaze -q 1080p "<title>"
kaze --trending
```

### Direct Playback (CLI)

Skip the menu and jump straight into an episode:

```bash
kaze -e 1 "<title>"
kaze -e 12 --dub "<title>"
kaze -e 1 --upscale modern "<title>"
```

### Subtitles & Dual Audio (SUB / DUB)

Kaze automatically configures mpv with English subtitle matching (`--slang=eng,en,enUS` and `--sub-auto=fuzzy`). You can control subtitles at two levels:

- **Before playback (in the TUI)**:
  - Press `Tab` to switch audio between Japanese (`SUB`) and English (`DUB`).
  - Press `Shift+J` (or `Ctrl+J`) to toggle subtitles between `[SUBS: ON]` and `[SUBS: OFF]` (default: `OFF`).
  - Toggle on with `Shift+J` whenever you want English subtitle tracks and signs displayed.
- **During playback (in mpv)**:
  - Press `j` / `Shift+J` to cycle through available subtitle tracks.
  - Press `v` to toggle subtitle visibility without leaving full screen.
  - Press `z` / `Z` to fine-tune subtitle sync delay (`-100ms` / `+100ms`).

### Command Flags

| Flag | Shorthand | Description | Default |
|:---|:---:|:---|:---:|
| `--sub` | `-s` | Prefer Japanese audio | `true` |
| `--dub` | `-d` | Prefer English dub (filters out unavailable eps) | `false` |
| `--quality` | `-q` | Video resolution (`auto`, `1080p`, `720p`, `480p`, `360p`, `2k`, `4k`, `off`) | `auto` |
| `--upscale` | — | Video enhancer shader (`off`, `retro`, `modern`) | `off` |
| `--episode` | `-e` | Directly play episode number (skips TUI menu) | `0` (TUI mode) |
| `--start-over` | `-r` | Play episode from 0:00 (ignore saved history bookmark) | `false` |
| `--trending` | `-t` | Show trending anime from AniList | `false` |
| `--skip` | — | Automatically skip openings and recaps | `false` |
| `--auto-next` | — | Automatically advance to next episode when done | `true` |
| `--auth` | — | Link AniList account for progress syncing | — |
| `--setup-shaders` | — | Download anime enhancement shaders locally | `false` |
| `--update` | `-u` | Check for updates and update Kaze in-place | `false` |
| `--status` | — | Print version and AniList sync status | — |

---

## Keybindings

### In the TUI

| Key | Action |
|:---|:---|
| `↑` / `↓` or `j` / `k` | Navigate search results and episode list |
| `Enter` | Select anime or play episode (auto-resumes from bookmark) |
| `r` / `R` | Start over highlighted episode from 0:00 (ignore saved bookmark) |
| `Tab` | Switch between SUB and DUB audio modes |
| `Shift+J` / `Ctrl+J` | Toggle subtitles on / off (`[SUBS: ON]` / `[SUBS: OFF]`, applies to both SUB and DUB) |
| `Ctrl+Q` / `q` | Cycle video quality (`auto ➔ 1080p ➔ 720p ➔ 480p ➔ 360p ➔ 2k ➔ 4k ➔ off`) |
| `Ctrl+U` / `u` | Cycle video shaders (`off ➔ retro ➔ modern ➔ off`) |
| `Ctrl+T` | Toggle between Search and Trending |
| `Ctrl+P` / `F2` | Toggle between AUTO (aggregated) and MANUAL mode |
| `s` | Toggle SmartSkip on / off |
| `n` | Toggle Binge Mode (auto-next) on / off |
| `Esc` | Go back / Exit |

### Inside MPV (During Playback)

| Key | Action |
|:---|:---|
| `j` / `Shift+J` | Cycle subtitle tracks |
| `v` | Toggle subtitle visibility on / off |
| `z` / `Z` | Adjust subtitle delay (-100ms / +100ms) |
| `s` / `S` | Skip opening theme / recap |
| `e` / `E` | Skip ending theme |
| `u` / `Ctrl+U` | Cycle shader enhancers live (`Retro ➔ Modern ➔ OFF`) |
| `Ctrl+1` | Activate Retro Deblur shader (1080p Mode B) |
| `Ctrl+2` | Activate Modern Sharp shader (1080p Mode A) |
| `Ctrl+3` / `Ctrl+4` | Stack: Modern Sharp + 2K / 4K Upscaler |
| `Ctrl+5` / `Ctrl+6` | Stack: Retro Deblur + 2K / 4K Upscaler |
| `Ctrl+7` / `Ctrl+8` | Pure 2K / 4K Upscaler (No line alteration) |
| `Ctrl+0` | Disable all shaders (pure native stream, zero GPU load) |
| `_` / `Ctrl+Q` | Cycle stream resolution |
| `i` / `Shift+I` | Show MPV playback stats (press `2` for active shaders & frame drop stats) |
| `Space` | Pause / Play |
| `←` / `→` | Seek -5s / +5s |
| `9` / `0` | Volume down / Volume up |
| `q` | Quit and save resume position |

---

## Security & Architecture

Kaze does not host or store any media. It acts purely as a terminal client feeding streams into mpv. The client is hardened against common network vulnerabilities:

- **SSRF Prevention**: All outbound HTTP requests pass through an IP-level validator that blocks loopback addresses (`127.0.0.1`, `localhost`), private RFC1918 subnets, IPv6 link-local addresses, and cloud metadata services (`169.254.169.254`).
- **Memory Bounds**: All HTTP response readers are wrapped in `io.LimitReader` buffers (capped at 32 MiB) to guard against compression bombs or infinite stream payloads.
- **No Headless Browsers**: Operates entirely with lightweight Go HTTP parsers. No Puppeteer, Selenium, or unvetted browser instances executing arbitrary JavaScript.
- **Secure IPC**: MPV communication uses sanitized JSON-RPC over native Windows named pipes (`\\.\pipe\kaze-mpv-*`) and Unix domain sockets, preventing shell command injection.
- **Distributed Gateways**: Connects across multiple independent gateways with automated failover and zero hardcoded tracking.

---

## License

This project is licensed under the [MIT License](LICENSE).
