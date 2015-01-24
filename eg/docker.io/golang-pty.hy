(require crank.language)
(import [crank.utils [gits]])


(build
  :source "golang-pty"
  :key "0x70DB41EB"
  :upstream "git://github.com/kr/pty.git"
  :version (-> (gits "log" "-1" "--date=short" "--pretty=0.0~git%ad.1.%h")
               (.replace "-" "")) ; 0.0~git20140315.1.67e2db2
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "vivid" "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/pkg-go/packages/golang-pty.git")
