class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e7e3437b8f118b17c4d7750e280d70f136fd7636924c3e78d474e4b4f3df0998"
  license "MIT"
  def install
    warn_about_legacy_install
    bin.install "catclip"
    pkgshare.install "VERSION"
  end

  def caveats
    <<~EOS
      A recent version of catclip switched from `ignore.yaml` to the new
      configuration file `~/.config/catclip/.hiss`.
      If you still have an old `ignore.yaml` file, you should delete it
      manually:
        rm ~/.config/catclip/ignore.yaml
      The new file will be created automatically the first time you run
      catclip.
    EOS
  end
  test do
    (testpath/"sample.txt").write("hi")
    output = shell_output("#{bin}/catclip --print sample.txt")
    assert_match "<file path=\"sample.txt\">", output
    assert_match "hi", output
  end

  private

  def warn_about_legacy_install
    legacy_binaries = [
      "/usr/local/bin/catclip",
      "/opt/homebrew/bin/catclip",
      "/usr/bin/catclip",
      "/bin/catclip",
      File.join(Dir.home, ".local/bin/catclip"),
    ].uniq
    legacy_binaries.each do |path|
      next unless File.exist?(path)

      opoo "Legacy catclip detected at #{path}; run `brew link --overwrite catclip` after install " \
           "so the keg can link cleanly."
    end
    legacy_versions = [
      "/usr/local/share/catclip/VERSION",
      "/opt/homebrew/share/catclip/VERSION",
      File.join(Dir.home, ".local/share/catclip/VERSION"),
    ].uniq
    legacy_versions.each do |path|
      next unless File.exist?(path)

      opoo "Legacy VERSION detected at #{path}; run `brew link --overwrite catclip` after install " \
           "so pkgshare can link its VERSION."
    end
  rescue Errno::ENOENT
    nil
  end
end
