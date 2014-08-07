(require crank.language)
(import [sh [cat git]])


(defn shs [cmd &rest args] (-> (apply cmd args) (str) (.strip)))
(defn gits [&rest args] (apply shs [git args]))
(defn cats [&rest args] (apply shs [cat args]))

(build
  :source "docker.io"
  :key "0x70DB41EB"
  :upstream "git://github.com/docker/docker.git"
  :version (-> (cats "VERSION") ; VERSION is something like "1.1.2-dev"
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
  :debian "git://git.debian.org/docker/docker.io.git"
  :debian-refspec "nightly")
