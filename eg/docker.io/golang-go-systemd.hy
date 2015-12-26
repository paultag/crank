(require crank.language)
(import [crank.utils [gits]])


(if false
(build
  :source "golang-go-systemd"
  :key "0x70DB41EB"
  :upstream "git://github.com/coreos/go-systemd.git"
  :version (do (gits "tag" "-d" "0") ; there's a "0" tag that screws up "git describe"
             (-> (gits "describe" "--tags")
               (.lstrip "v")
               (.replace "-" "+"))) ; "2+27+g97e243d"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "wily" "vivid" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-go-systemd.git")
)
