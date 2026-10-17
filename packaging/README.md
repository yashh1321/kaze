# Kaze Packaging Manifests

This directory contains distribution recipes for package managers permitted under Section 3(d) of the Kaze Freeware EULA.

---

## 1. Windows (Scoop)
To host your own Scoop bucket:
1. Create a public repository on GitHub named `scoop-kaze` (or `scoop-bucket`).
2. Put `packaging/scoop/kaze.json` into a `bucket/` folder in that repo:
   ```
   scoop-kaze/
   └── bucket/
       └── kaze.json
   ```
3. Users can then install Kaze with:
   ```powershell
   scoop bucket add kaze https://github.com/yashh1323/scoop-kaze
   scoop install kaze
   ```

---

## 2. macOS & Linux (Homebrew Tap)
To host your own Homebrew tap:
1. Create a public repository on GitHub named `homebrew-kaze`.
2. Put `packaging/homebrew/kaze.rb` into a `Formula/` folder in that repo:
   ```
   homebrew-kaze/
   └── Formula/
       └── kaze.rb
   ```
3. Users can then install Kaze with:
   ```bash
   brew tap yashh1323/kaze
   brew install kaze
   ```

---

## 3. Arch Linux (AUR)
Submit `packaging/aur/PKGBUILD` as `kaze-bin` on the Arch User Repository (AUR).
Users can then install with:
```bash
yay -S kaze-bin
```
