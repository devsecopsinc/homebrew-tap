class Crc < Formula
  desc "Manage Claude Code remote-control servers, one per workspace, in tmux"
  homepage "https://github.com/devsecopsinc/claude-remote-control"
  url "https://github.com/devsecopsinc/claude-remote-control/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "cd19698bb43011cadb7912e95a78120209817ad212749f860ad39a9d924ac21a"
  license "MIT"
  head "https://github.com/devsecopsinc/claude-remote-control.git", branch: "main"

  depends_on "tmux"

  def install
    libexec.install "bin", "lib", "hooks"
    # crc resolves symlinks to find lib/, so a symlink into bin is enough.
    bin.install_symlink libexec/"bin/crc"
  end

  def caveats
    <<~EOS
      Claude Code itself is not installed by this formula:
        https://docs.claude.com/claude-code

      Register a workspace and start its server:
        crc add work --repo git@github.com:you/work.git

      To start servers at boot and restart them if they die (asks for sudo):
        crc supervise install

      Config lives in ~/.crc; logs in ~/Library/Logs/claude-remote-control.
      Before uninstalling, run: crc supervise uninstall
    EOS
  end

  test do
    assert_match "crc", shell_output("#{bin}/crc version")
    ENV["CRC_HOME"] = testpath/"crc"
    assert_match "no servers registered", shell_output("#{bin}/crc list")
  end
end
