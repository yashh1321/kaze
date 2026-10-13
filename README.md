<p align="center">
  <h1 align="center">KAZE (風)</h1>
  <p align="center"><b>The fastest, zero-dependency, autonomous anime CLI & MPV player in pure Go.</b></p>
  <p align="center">
    <a href="https://github.com/Yash-Kashyap/kaze/actions"><img src="https://img.shields.io/badge/Build-Passing-brightgreen?style=flat-square" alt="Build Status"></a>
    <a href="https://golang.org"><img src="https://img.shields.io/badge/Go-1.24-00ADD8?style=flat-square&logo=go" alt="Go Version"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="License"></a>
    <a href="https://github.com/Yash-Kashyap/kaze/releases"><img src="https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-orange?style=flat-square" alt="Platforms"></a>
  </p>
</p>

---

## ⚡ What is Kaze?

**KAZE (風)** is a high-performance terminal anime client and aggregator engineered from scratch in pure Go. Unlike shell scripts (`ani-cli`) or heavy Python runtimes (`mov-cli`, `anipy-cli`), Kaze compiles into a single standalone binary with sub-15ms startup latency and zero runtime dependencies (except MPV for video rendering).

Kaze aggregates multiple anime networks concurrently, deduplicates results in real-time, features instant multi-CDN failover, and provides native **SmartSkip** (intro/outro skipping) and watch history bookmarking without needing any browser extensions, shell scripts, or external Lua plugins.

---

## 📊 Comparison Matrix

| Feature | **KAZE (風)** | `ani-cli` | `mov-cli` | `anipy-cli` |
|:---|:---:|:---:|:---:|:---:|
| **Language** | **Pure Go (100% Native)** | Bash / POSIX Shell | Python | Python |
| **Distribution** | **Single static executable (~11 MB)** | Multi-file scripts | 50+ MB virtualenv | 40+ MB virtualenv |
| **Startup Latency** | **< 15ms** | ~400ms (subshell forks) | ~1.8s | ~1.5s |
| **External Dependencies** | **None** *(only `mpv`)* | `curl, sed, grep, fzf, etc.` | Python, pip, Node.js | Python, pip |
| **Concurrent Multi-Search** | **Yes** *(goroutine fan-out)* | No *(single provider)* | No | No |
| **Auto Failover (`AUTO`)** | **Yes** *(seamless CDN fallback)* | Manual restart | None | None |
| **Intro/Outro Skipping** | **Native SmartSkip Engine** | Requires `ani-skip` + Lua | None | None |
| **MPV Shortcut Key (`s`)** | **Built-in IPC keybinding** | Requires external script | None | None |
| **Resume Bookmarks** | **Built-in (`~/.kaze/history.json`)** | Basic logger | Limited | None |
| **Binge Mode (Auto-Next)** | **Built-in continuous playback** | Interactive prompt | Manual | Manual |
| **Windows Support** | **First-Class Native (Named Pipes)** | Requires WSL/Cygwin | Moderate | Moderate |

---

## 🌟 Key Features

## 🌟 Key Features

- 🏎️ **Concurrent Multi-Provider Fan-Out:** Queries multiple high-speed networks concurrently via non-blocking goroutines. Search results stream in live as providers complete.
- 🛡️ **Autonomous Failover (`AUTO` Mode):** Duplicate titles across networks are automatically consolidated into single unified entries. If stream host A is unreachable or slow, Kaze transparently falls back to host B.
- 🎨 **Real-Time Video Enhancer & Upscaling:** Dual shader engines tailored for anime art styles:
  - **Retro Deblur (Mode B):** Cleans up blur, ringing, and compression artifacts on 480p/720p classics.
  - **Modern Sharp (Mode A):** Reconstructs crisp, thin line art on contemporary digital anime.
  - **2K / 4K Upscaling:** GPU-accelerated texture enlargement for high-resolution displays.
- ⏭️ **Native SmartSkip Engine:** Automatic intro, recap, and outro detection via crowd-sourced anime timing data. Automatically skips opening songs or press `s` directly inside MPV to jump past the intro anytime.
- 🔖 **Watch History & Auto-Resume:** Tracks your playback progress and completion status. Shows `✓` for watched episodes and `▶ [14:20]` for in-progress episodes, automatically resuming playback from where you stopped.
- 🍿 **Binge Mode (Auto-Next):** Continuous hands-free playback. When an episode completes, Kaze automatically resolves and loads the next episode.
- 🎛️ **Dual-Mode Interactive TUI:** Built with Charm Bracelet's Bubble Tea. Press `Ctrl+P` or `F2` anytime to toggle between unified `[AUTO]` deduplication and raw `[MANUAL]` provider view.
- 🌐 **Dynamic Sub & Dub Tracking:** Real-time episode availability. When DUB is selected, Kaze automatically filters and displays only available dubbed episodes, updating automatically as new episodes air.

---

## 📥 Installation

### Windows (PowerShell One-Liner)

```powershell
irm https://raw.githubusercontent.com/Yash-Kashyap/kaze/main/install.ps1 | iex
```

### Linux / macOS (Bash One-Liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Yash-Kashyap/kaze/main/install.sh | bash
```

### Via Go

```bash
go install github.com/Yash-Kashyap/kaze/cmd/kaze@latest
```

### Build from Source

```bash
git clone https://github.com/Yash-Kashyap/kaze.git
cd kaze
go build -ldflags="-s -w" -o kaze.exe ./cmd/kaze
```

> **Requirement:** Kaze uses [MPV](https://mpv.io) for hardware-accelerated video rendering. Make sure `mpv` is installed:
> - **Windows:** `scoop install mpv` or `winget install mpv.net`
> - **macOS:** `brew install mpv`
> - **Linux:** `sudo apt install mpv` / `pacman -S mpv`

---

## 🚀 Usage

### Interactive TUI

Simply run `kaze` with an optional search term:

```bash
kaze "<title>"
kaze --dub "<title>"
kaze -q 1080p "<title>"
kaze --trending
```

### Direct Episode Playback (CLI Mode)

Skip the menu and play an episode directly with automatic provider failover:

```bash
kaze --episode 1 "<title>"
kaze -e 5 --dub "<title>"
kaze -e 1 --upscale retro "<title>"
```

### Playback Options

| Flag | Shorthand | Description | Default |
|:---|:---:|:---|:---:|
| `--sub` | `-s` | Prefer English subtitles | `true` |
| `--dub` | `-d` | Prefer English audio dub (auto-filters available eps) | `false` |
| `--quality` | `-q` | Output resolution (`auto`, `1080p`, `720p`, `480p`, `360p`, `2k`, `4k`, `off`) | `auto` |
| `--upscale` | — | Real-time enhancer (`off`, `retro`, `modern`) | `off` |
| `--episode` | `-e` | Directly play specified episode number | `0` (TUI mode) |
| `--trending`| `-t` | Browse top trending anime from AniList | `false` |
| `--skip` | — | Auto-skip openings/endings via SmartSkip | `true` |
| `--auto-next` | — | Binge mode: auto-advance to next episode | `true` |
| `--setup-shaders` | — | Pre-download video enhancement shaders locally | `false` |
| `--auth` | — | Connect AniList account for progress synchronization | — |
| `--status` | — | Display version and AniList sync status | — |

---

## ⌨️ Keyboard Shortcuts

### In the TUI

| Key | Action |
|:---|:---|
| `↑` / `↓` or `j` / `k` | Navigate search results or episode list |
| `Enter` | Select anime / play episode *(auto-resumes from bookmark)* |
| `Tab` | Toggle audio between **SUB** and **DUB** *(dynamically updates episode count)* |
| `Ctrl+Q` / `q` | Cycle quality: `AUTO ➔ 1080p ➔ 720p ➔ 480p ➔ 360p ➔ 2K ➔ 4K ➔ OFF` |
| `Ctrl+U` / `u` | Cycle enhancer: `OFF ➔ RETRO ➔ MODERN ➔ OFF` |
| `Ctrl+T` | Toggle between Search and Trending anime |
| `Ctrl+P` / `F2` | Toggle between **AUTO** (aggregated) and **MANUAL** provider mode |
| `s` | Toggle SmartSkip on / off *(auto-skips OP/ED)* |
| `n` | Toggle Binge Mode on / off *(auto-plays next ep)* |
| `Esc` | Return to previous view / Quit |

### Inside MPV (During Playback)

| Key | Action |
|:---|:---|
| `u` / `Ctrl+U` | **Cycle Enhancer live** *(Retro ➔ Modern ➔ OFF)* |
| `Ctrl+1` | **Enhancer: Retro Deblur** *(cleans 480p/720p classics)* |
| `Ctrl+2` | **Enhancer: Modern Sharp** *(sharpens modern digital line art)* |
| `Ctrl+0` | **Enhancer: OFF** *(native untouched stream, zero GPU load)* |
| `Ctrl+3` | **Quality: 2K Upscaler** *(1440p output)* |
| `Ctrl+4` | **Quality: 4K Ultra Upscaler** *(2160p output)* |
| `_` / `Ctrl+Q` | Cycle video stream resolution live |
| `Shift+I` / `i` | **MPV Stats overlay** *(press `2` to view active shaders & GPU render ms)* |
| `s` / `S` | **Instantly skip opening theme** |
| `e` / `E` | **Instantly skip ending theme** |
| `Space` | Pause / Resume |
| `←` / `→` | Seek -5s / +5s |
| `9` / `0` | Volume down / Volume up |
| `q` | Quit playback and save bookmark position |

---

## 🏗️ Architecture & Security
 
```
                 ┌─────────────────────────────────┐
                 │       Kaze CLI / BubbleTea      │
                 └────────────────┬────────────────┘
                                  │ Concurrent Fan-Out (goroutines)
       ┌──────────────┬───────────┼───────────┬──────────────┐
       ▼              ▼           ▼           ▼              ▼
 ┌───────────┐  ┌───────────┐ ┌───────┐ ┌───────────┐  ┌───────────┐
 │  Node-A   │  │  Node-H   │ │Node-M │ │  Node-G   │  │  Node-P   │
 └─────┬─────┘  └─────┬─────┘ └───┬───┘ └─────┬─────┘  └─────┬─────┘
       └──────────────┴───────────┼───────────┴──────────────┘
                                  │ Validated Streams (SSRF Filtered)
                                  ▼
                 ┌─────────────────────────────────┐
                 │        MPV Media Player         │
                 │   (Hardware-Accelerated Render) │
                 └────────────────┬────────────────┘
                                  │ Bidirectional IPC
                                  ▼
                 ┌─────────────────────────────────┐
                 │    Kaze SmartSkip Controller    │
                 │     & Watch History Manager     │
                 └─────────────────────────────────┘
```

- **Pure Go Engine:** No CGO, no node_modules, no python packages, zero runtime dependencies except `mpv`.
- **Zero Headless Browsers:** No unvetted browser automation or arbitrary JavaScript evaluation. Eliminates drive-by scripts and sandbox escape risks.
- **SSRF & Intranet Defense:** Strict URL validation blocks private IPv4 subnets, IPv6 link-local addresses, loopback endpoints (`localhost`, `127.0.0.1`), and cloud metadata services (`169.254.169.254`).
- **Memory & Stream Bounds:** All HTTP client bodies enforce `io.LimitReader` buffers (`32 MiB`) to prevent memory exhaustion and decompression bombs.
- **IPC Architecture:** Uses native Windows named pipes (`\\.\pipe\kaze-mpv-*`) and Unix domain sockets with JSON-RPC parameterization to prevent command injection.

---

## 📄 License

Licensed under the [MIT License](LICENSE). Free for personal and educational use.
