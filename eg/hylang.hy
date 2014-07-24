(require crank.language)
(import [sh [git]])


(build
  :source "hy"
  :key "0x70DB41EB"
  :upstream "git://github.com/hylang/hy.git"
  :version (+ (.strip (.replace (git "describe") "-" "+"))
              (.format "+{}" (.strftime (datetime.datetime.utcnow) "%Y%m%d")))
  :maintainer "Nightly Build <team@hylang.org>"
  :suites "trusty" "precise"
  :target "ppa:hy-society/nightly"
  :debian "git://git.debian.org/collab-maint/hy.git")
