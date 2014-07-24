(import [crank.utils [group-map one]])


(defmacro in-workdir [&rest params]
  "Run the forms in a temporary directory and remove it."
  `(do (import [crank.utils [cdtmp]])
       (with [[(cdtmp)]] ~@params)))


(defmacro/g! build [&rest params]
  (let [[mapping (group-map keyword? params)]]
    `(do (import [crank.utils [git-clone git-clone-debian
                               prepare-changelog prepare-source
                               build-tarball]]
                 [os [chdir]])
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
           (prepare-changelog version "trusty")
           (prepare-source)))))
