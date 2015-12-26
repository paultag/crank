(require crank.language)
(import [crank.utils [dates gits]])


(build
  :source "gb"
  :key "0x70DB41EB"
  :upstream "git://github.com/constabulary/gb.git"
  :version (-> (gits "describe" "--tags")
                (.lstrip "v")
                (.replace "-" "+")) ; "0.3.5+18+gd5cee82"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~gb-maint/+archive/ubuntu/nightly/+files/{source}_{version}.dsc"
  :suites "xenial" "wily" "vivid" "trusty"
  :target "ppa:gb-maint/nightly"
  :debian "git://git.debian.org/pkg-go/packages/gb.git"
  :debian-refspec "master")
