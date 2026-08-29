class Crc < Formula
  desc "Manage Claude Code remote-control servers, one per workspace, in tmux"
  homepage "https://github.com/devsecopsinc/claude-remote-control"
  url "https://github.com/devsecopsinc/claude-remote-control/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "77a257342fff6bc2ebbd2cbb222246dd241a068fef9060dc1c8718c5a34982dc"
  license "MIT"
  head "https://github.com/devsecopsinc/claude-remote-control.git", branch: "main"

  depends_on "tmux"

  def install
    libexec.install "bin", "lib"
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
