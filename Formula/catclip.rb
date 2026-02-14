class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "f2ddbd28f967375f211b8bb5f3d0409bba737eac0d597b97bb67baa3cfd5d804"
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
