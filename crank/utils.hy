(import [collections [defaultdict]]
        [tempfile [mkdtemp]]
        [contextlib [contextmanager]]
        [os [chdir getcwd]]
        [shutil [rmtree]]
        [functools [reduce]])


(with-decorator contextmanager (defn cdtmp []
  (setv tdir (mkdtemp))
  (setv popd (getcwd))
  (chdir tdir)
  (yield)
  (chdir popd)
  (rmtree tdir)))


(defn one [default args]
  "Get a single element back from the keyvector"
  (cond
    [(= (len args) 0) default]
    [(= (len args) 1) (get args 0)]
    [true (raise (TypeError "Too many args passed in."))]))


(defn key-value-stream [key? stream]
  "Stream the key-value pairs back"
  (let [[key nil]]
    (for [x stream]
      (if (key? x)
        (setv key x)
        (yield [key x])))))


(defn group-map [key? stream]
  "Create a defaultdict from a keyvector"
  (reduce
    (fn [accum v]
      (let [[(, key value) v]]
        (.append (get accum key) value))
      accum)
    (key-value-stream key? stream)
    (defaultdict list)))
