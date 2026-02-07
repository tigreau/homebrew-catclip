class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "dea438dfb6096ddee1f663b252b94c7ad8438b0d0b0640f70dfab5f16de44a47"
  license "MIT"

  def install
    bin.install "catclip"
    pkgshare.install "ignore.yaml", "VERSION"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"config/catclip").mkpath
    cp pkgshare/"ignore.yaml", testpath/"config/catclip/ignore.yaml"

    (testpath/"sample.txt").write("hi")
    output = shell_output("#{bin}/catclip --print sample.txt")
    assert_match "# File: sample.txt", output
    assert_match "hi", output
  end
end
