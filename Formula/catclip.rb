class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "11c3e230c6a5be3fc20fd8efca2f9e38b0846a7c3db8f10fc308f3103b93099f"
  license "MIT"

  def install
    bin.install "catclip"
    bin.install "VERSION"
    pkgshare.install "ignore.yaml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"sample.txt").write("hi")
    output = shell_output("#{bin}/catclip --print sample.txt")
    assert_match "# File: sample.txt", output
    assert_match "hi", output
  end
end
