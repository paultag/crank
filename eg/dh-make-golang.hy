(require crank.language)
(import [crank.utils [dates gits]])


(build
  :source "dh-make-golang"
  :key "0x70DB41EB"
  :upstream "git://github.com/Debian/dh-make-golang.git"
  :version (+ "0.0~git"
              (dates "--date" (gits "log" "-1" "--pretty=@%at")
                     "+%Y%m%d.%H%M%S")
              ".0."
              (gits "log" "-1" "--format=%h")) ; 0.0~git20141217.141937.0.05017fc-1
  :maintainer-email "doulos@metatron.pault.ag"
  :maintainer-name "Paul's Doulos"
;  :upload-location "https://launchpad.net/~hy-society/+archive/ubuntu/nightly/+files/{source}_{version}.dsc"
  :suites "jessie" "stretch" "sid"
;  :target "ppa:hy-society/nightly"
  :debian "git://git.debian.org/pkg-go/packages/dh-make-golang.git"
  :debian-refspec "master")
