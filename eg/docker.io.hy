(require crank.language)
(import [crank.utils [cats gits]]
  [os [listdir]]
  [os.path [abspath join splitext]]
  [hy.importer [import_file_to_hst]])


; load/build deps first
(let [[dir (-> __file__ abspath (splitext) (. [0]))]]
  (for [name (sorted (listdir dir))]
       (if (!= (-> name (splitext) (. [1])) ".hy") (continue))
       (print "Loading" name)
       (for [form (import_file_to_hst (join dir name))]
            (eval form))
       (print)))


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
  :upload-location "https://launchpad.net/~docker-maint/+archive/ubuntu/testing/+files/{source}_{version}.dsc"
  :suites "utopic" "trusty"
  :target "ppa:docker-maint/testing"
  :debian "git://git.debian.org/docker/docker.io.git"
  :debian-refspec "nightly")
