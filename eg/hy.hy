(require crank.language)
(import [crank.utils [gits]])


(build
  :source "hy"
  :key "0x70DB41EB"
  :upstream "git://github.com/hylang/hy.git"
  :version (.replace (gits "describe") "-" "+")
  :maintainer-email "doulos@metatron.pault.ag"
  :maintainer-name "Paul's Doulos"
  :upload-location "https://launchpad.net/~hy-society/+archive/ubuntu/nightly/+files/{source}_{version}.dsc"
  :suites "vivid" "utopic" "trusty"
  :target "ppa:hy-society/nightly"
  :debian "git://git.debian.org/pkg-hy/hy.git"
  :debian-refspec "nightly")
