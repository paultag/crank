(require crank.language)
(import [sh [cat git]])


(defn gits [&rest args] (-> (apply git args) (str) (.strip)))

(build
  :source "docker.io"
  :key "0x70DB41EB"
  :upstream "git://github.com/docker/docker.git"
  :version (-> (cat "VERSION") ; VERSION is something like "1.1.2-dev"
               (.replace "-" "+")
               (.replace "dev" (+ (gits "rev-list" "HEAD" "--count")
                                  "+"
                                  (gits "rev-parse" "--short" "HEAD"))))
           ; all this gets us something nice like "1.1.2+9849+d48492a"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/docker.io_{version}.dsc"
  :suites "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/docker/docker.io.git")
