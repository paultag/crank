(require crank.language)
(import [sh [git]])


(build
  :upstream "git://github.com/hylang/hy.git"
  :version (.replace (git "describe") "-" "+")
  :maintainer "Nightly Build <team@hylang.org>"
  :suites "trusty"
  :target "ppa:hy-society/nightly"
  :debian "git://git.debian.org/collab-maint/hy.git")
