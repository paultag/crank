(import [collections [defaultdict]]
        [tempfile [mkdtemp]]
        [contextlib [contextmanager]]
        [os [chdir getcwd]]
        [os.path [exists join]]
        [glob [glob]]
        [sh [git svn tar dch dpkg-buildpackage debsign]]
        [shutil [rmtree move]]
        [functools [reduce]])


(with-decorator contextmanager (defn cdtmp []
  (setv tdir (mkdtemp))
  (setv popd (getcwd))
  (chdir tdir)
  (try (yield)
       (finally
         (chdir popd)
         (rmtree tdir)))))


(defn prepare-changelog [version suite]
  (let [[dversion (.format "{}-1~{}1" version suite)]]
    (dch "--newversion"
         (.format "{}-1~{}1" version suite)
         "--force-distribution"
         "--distribution" suite
         "Automated rebuild.")
    dversion))


(defn prepare-source []
  (dpkg-buildpackage "-us" "-uc" "-S" "-nc"))


(defn sign-source [path key]
  (debsign (.format "-k{}" key) path))


(defn repo-clone [url dest &optional refspec]
  (if (.startswith url "svn://")
    (svn "checkout" (lif refspec ["-r" refspec]) url dest)
    (git "clone" (lif refspec ["-b" refspec]) url dest)))


(defn repo-clone-debian [url &optional refspec]
  (setv dest (getcwd))
  (with [[(cdtmp)]]
    (repo-clone url "debian" refspec)
    (if (exists "./debian/debian/")
        (move "./debian/debian/" dest)
        (move "./debian/" dest))))


(defn build-tarball [source version]
  (let [[tarball (.format "{}_{}.orig.tar.gz" source version)]]
    (git "archive" "-o" (.format "../{}" tarball) "--format" "tar.gz" "HEAD")
    tarball))

    ; (tar "-zcvf"
    ;   (.format "../{}" tarball)
    ;   (.format "../{}" source))
    ; tarball))


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
