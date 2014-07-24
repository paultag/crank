(import [crank.utils [group-map one]])


(defmacro in-workdir [&rest params]
  "Run the forms in a temporary directory and remove it."
  `(do (import [crank.utils [cdtmp]])
       (with [[(cdtmp)]] ~@params)))


(defmacro/g! build [&rest params]
  (let [[mapping (group-map keyword? params)]]
    `(do (import dput datetime
                 [crank.utils [git-clone git-clone-debian
                               prepare-changelog prepare-source
                               sign-source build-tarball]]
                 [glob [glob]]
                 [os [chdir]])
         (for [dist [~@(:suites mapping)]]
           (print "Building for" dist)
           (in-workdir
             (setv source ~(one 'nil (:source mapping)))

             (print "Cloning into" source "(just a sec)")
             (git-clone ~(one 'nil (:upstream mapping)) source)
             (chdir source)

             (setv version (.strip ~(one 'nil (:version mapping))))
             (print "Building version" version)

             (setv tarball (build-tarball source version))
             (print "Tarball built as" tarball)

             (git-clone-debian ~(one 'nil (:debian mapping)))
             (print "Debian overlay pulled down")

             (prepare-changelog version dist)
             (print "Changelog prepared.")
             (prepare-source)
             (print "Source distribution prepared.")
             (let [[(, changes) (glob (.format "../{}*{}*source*changes" source version))]
                   [key ~(one 'nil (:key mapping))]
                   [target ~(one 'nil (:target mapping))]]
               (print "Signing" changes "with" key)
               (sign-source changes key)
               (print "Uploading" changes "to" target)
               (dput.upload changes target)))))))
