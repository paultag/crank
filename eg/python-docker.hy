(require crank.language)
(import [sh [cat git]])


(defn shs [cmd &rest args] (-> (apply cmd args) (str) (.strip)))
(defn gits [&rest args] (apply shs [git args]))

(build
  :source "python-docker"
  :key "0x70DB41EB"
  :upstream "git://github.com/docker/docker-py.git"
  :version (-> (gits "describe" "--tags") ; "0.4.0-8-g14f9c07"
               (.replace "-" "+"))        ; "0.4.0+8+g14f9c07"
  :maintainer-email "admwiggin@gmail.com"
  :maintainer-name "Tianon Gravi"
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "svn://anonscm.debian.org/python-modules/packages/python-docker/trunk")
