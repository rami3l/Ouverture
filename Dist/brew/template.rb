class Ouverture < Formula
    desc "A default application modifier for macOS."
    homepage "https://github.com/rami3l/Ouverture"
    version "{version}"
    url "{url_mac}"
    sha256 "{sha256_mac}"

    def install
      bin.install "ovt"
    end
end