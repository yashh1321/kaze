class Kaze < Formula
  desc "Lightweight terminal anime client and media player controller with mpv"
  homepage "https://github.com/yashh1323/kaze"
  version "4.3.0"
  license "Freeware"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/yashh1323/kaze/releases/download/v4.3.0/kaze-darwin-amd64.tar.gz"
      sha256 "e83228838f212dc9996aca9815c5224ac35ea18a4404e400f4cc618ff09d8a24"
    elsif Hardware::CPU.arm?
      url "https://github.com/yashh1323/kaze/releases/download/v4.3.0/kaze-darwin-arm64.tar.gz"
      sha256 "76bd3b9302c6db610e987618270bacff96b6859afeac1bc04bc6449a36eaa32d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/yashh1323/kaze/releases/download/v4.3.0/kaze-linux-amd64.tar.gz"
      sha256 "f1e6d7fc7d14fb9b76f6c592eaeff542cda038d09d6cc7b1f544a048115da58a"
    elsif Hardware::CPU.arm?
      url "https://github.com/yashh1323/kaze/releases/download/v4.3.0/kaze-linux-arm64.tar.gz"
      sha256 "07b774b3fdc0fbe1c9da3629cf8121f2ba7f8b3259e49f888d811edf80a6661e"
    end
  end

  depends_on "mpv"

  def install
    bin.install "kaze"
  end

  test do
    assert_match "Kaze v#{version}", shell_output("#{bin}/kaze --version")
  end
end
