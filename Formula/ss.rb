class Ss < Formula
  desc "Slide description language and CLI"
  homepage "https://github.com/abap34/ss"
  url "https://github.com/abap34/ss/releases/download/v0.8.0/ss-0.8.0.tar.gz"
  version "0.8.0"
  sha256 "29f5c2e0f6c8be6e16a6456f2aa638f3fc93d0d7353fb83aa2583c724b48afd6"
  license "Apache-2.0"

  depends_on "zig" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "qpdf"

  def install
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

      LaTeX math rendering requires an external TeX distribution that provides
      the configured pdflatex or lualatex engine, such as MacTeX or BasicTeX.
    EOS
  end

  test do
    (testpath/"slide.ss").write <<~EOS
      import std:themes/default as *

      page home
      cover!("Homebrew", "ss formula smoke", "v#{version}")
      end
    EOS

    assert_match version.to_s, shell_output("#{bin}/ss --version")
    system bin/"ss", "check", testpath/"slide.ss"
  end
end
