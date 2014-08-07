(require crank.language)
(import [crank.utils [gits]])


(build
  :source "golang-go-patricia"
  :key "0x70DB41EB"
  :upstream "git://github.com/tchap/go-patricia.git"
  :version (-> (gits "describe" "--tags")
               (.lstrip "v")
               (.replace "-" "+")) ; "1.0.0+5+g818ed1c"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-go-patricia.git")
