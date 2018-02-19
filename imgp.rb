class Imgp < Formula
  include Language::Python::Virtualenv

  desc "Resize, rotate JPEG and PNG images."
  homepage "https://github.com/jarun/imgp"
  url "https://github.com/jarun/imgp/archive/v2.4.1.tar.gz"
  sha256 "6f810104f80f23c1c0967e156921b971947e902d6809c5dae2885777c996eae0"

  depends_on :python3

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
