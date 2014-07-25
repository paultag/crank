(require crank.language)
(import [sh [git]])


(build
  :source "hy"
  :key "0x70DB41EB"
  :upstream "git://github.com/hylang/hy.git"
  :version (.replace (git "describe") "-" "+")
  :maintainer "Nightly Build <team@hylang.org>"
  :suites "utopic" "trusty"
  :target "ppa:hy-society/nightly"
  :debian "git://git.debian.org/collab-maint/hy.git")
