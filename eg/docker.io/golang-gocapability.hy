(require crank.language)
(import [crank.utils [dates gits]])


(build
  :source "golang-gocapability-dev"
  :key "0x70DB41EB"
  :upstream "git://github.com/syndtr/gocapability.git"
  :version (+ "0.0~git"
              (dates "--date" (gits "log" "-1" "--pretty=@%at")
                     "+%Y%m%d.%H%M%S")
              ".0."
              (gits "log" "-1" "--format=%h")) ; 0.0~git20141217.141937.0.05017fc-1
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "vivid" "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-gocapability-dev.git")
