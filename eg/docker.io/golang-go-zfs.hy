(require crank.language)
(import [crank.utils [gits]])


(build
  :source "golang-go-zfs"
  :key "0x70DB41EB"
  :upstream "git://github.com/mistifyio/go-zfs.git"
  :version (-> (gits "describe" "--tags")
               (.lstrip "v")
               (.replace "-" "+")) ; "0.6.4+15+g7f14e05"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "wily" "vivid" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-go-zfs.git")
