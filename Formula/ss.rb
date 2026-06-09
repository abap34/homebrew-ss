class Ss < Formula
  desc "Slide description language and CLI"
  homepage "https://github.com/abap34/ss"
  url "https://github.com/abap34/ss/releases/download/v0.4.2/ss-0.4.2.tar.gz"
  sha256 "a0b44999c65729859a42028297b61c64c2c2edb2fd62e7b7ffc763270b677c7c"
  license "Apache-2.0"

  depends_on "zig" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "imagemagick"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "poppler"
  depends_on "qpdf"

  resource "md4c" do
    url "https://codeload.github.com/mity/md4c/tar.gz/472c417005c2c71b8617de4f7b8d6b30411d78f4"
    sha256 "ecbd85292465df929839897e314d809b5c8b267e20c4e5e24d51a1602d16d99a"
  end

  def install
    mkdir_p buildpath/"third_party"
    resource("md4c").stage buildpath/"third_party/md4c"

    system "zig", "build",
      "-Doptimize=ReleaseSafe",
      "-Dversion=#{version}",
      "-Dcommit=homebrew",
      "install",
      "--prefix", prefix
  end

  def caveats
    <<~EOS
      The VS Code extension does not bundle ss. Keep #{opt_bin}/ss on PATH or
      set the extension's ss.cli.path setting to #{opt_bin}/ss.

      LaTeX math rendering requires an external TeX distribution such as
      MacTeX or BasicTeX.
    EOS
  end

  test do
    (testpath/"slide.ss").write <<~EOS
      import std:themes/default

      page home
      cover("Homebrew", "ss formula smoke", "v#{version}")
      end
    EOS

    assert_match version.to_s, shell_output("#{bin}/ss --version")
    system bin/"ss", "check", testpath/"slide.ss"
  end
end
