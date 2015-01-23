(require crank.language)
(import [crank.utils [gits]])


(build
  :source "golang-fsnotify"
  :key "0x70DB41EB"
  :upstream "git://github.com/go-fsnotify/fsnotify.git"
  :version (-> (gits "describe" "--tags")
               (.lstrip "v")
               (.replace "-" "+")) ; "1.1.0+11+g8f4d598"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-fsnotify.git")
