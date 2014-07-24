(import [crank.utils [group-map one]])


(defmacro in-workdir [&rest params]
  "Run the forms in a temporary directory and remove it."
  `(do (import [crank.utils [cdtmp]])
       (with [[(cdtmp)]] ~@params)))


(defmacro/g! build [&rest params]
  (let [[mapping (group-map keyword? params)]]
    `(in-workdir
       (print "Hello"))))
