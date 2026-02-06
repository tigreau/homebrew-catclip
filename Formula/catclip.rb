class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "00c08960311dc9023eade9922f59eb87451be541bff9ecfeeb106973de684f0a"
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
