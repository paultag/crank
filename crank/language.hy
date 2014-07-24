(import [crank.utils [group-map one]])


(defmacro/g! build [&rest params]
  (let [[mapping (group-map keyword? params)]]
    (print (:suites mapping))))
