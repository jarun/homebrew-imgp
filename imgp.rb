class Imgp < Formula
  include Language::Python::Virtualenv

  desc "Resize, rotate JPEG and PNG images."
  homepage "https://github.com/jarun/imgp"
  url "https://github.com/jarun/imgp/archive/v2.6.tar.gz"
  sha256 "f79d35b4337269b51f166e80a5e8e39f08f33f7843733d3ed85795bbe1eea799"

  depends_on "python3"

  def install
    virtualenv_create(libexec, "python3")
    # Building Pillow from source is a PITA; even homebrew/science/pillow can't
    # do it right. Let's just use an upstream wheel. Note that this is against
    # the policies of homebrew/core, and it probably won't work against
    # Linuxbrew.
    system libexec/"bin/pip", "install", "Pillow"

    inreplace "imgp", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"
    bin.install "imgp"
    man1.install "imgp.1"
  end

  test do
    cp test_fixtures("test.png"), testpath
    system bin/"imgp", "-x", "4x4", testpath/"test.png"
    assert_predicate testpath/"test_IMGP.png", :exist?
  end
end
