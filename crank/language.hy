(import [crank.utils [group-map one]])


(defmacro in-workdir [&rest params]
  "Run the forms in a temporary directory and remove it."
  `(do (import [crank.utils [cdtmp]])
       (with [[(cdtmp)]] ~@params)))


(defmacro/g! build [&rest params]
  (let [[mapping (group-map keyword? params)]]
    `(do (import [crank.utils [git-clone]]
                 [os [chdir]])
         (in-workdir
           (setv source ~(one 'nil (:source mapping)))
           (print "Cloning into" source "(just a sec)")
           (git-clone ~(one 'nil (:upstream mapping)) source)
           (chdir source)
           (setv version ~(one 'nil (:version mapping)))
           (print "Building version" version)
))))
