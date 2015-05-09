(require crank.language)
(import [crank.utils [gits]])


(build
  :source "golang-blackfriday"
  :key "0x70DB41EB"
  :upstream "git://github.com/russross/blackfriday.git"
  :version (-> (gits "describe" "--tags")
               (.lstrip "v")
               (.replace "-" "+")) ; "1.1+136+g2e7d690"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "wily" "vivid" "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-blackfriday.git")
