(import [collections [defaultdict]]
        [tempfile [mkdtemp]]
        [contextlib [contextmanager]]
        [os [chdir getcwd listdir]]
        [os.path [abspath exists join splitext]]
        [glob [glob]]
        [sh [git svn tar dch dpkg-buildpackage debsign cat date]]
        [shutil [rmtree move]]
        [functools [reduce]])


; nice user-facing helpers (especially for :version)
(defn shs [cmd &rest args] (-> (apply cmd args) (str) (.strip)))
(defn gits [&rest args] (apply shs [git "--no-pager" args]))
(defn cats [&rest args] (apply shs [cat args]))
(defn dates [&rest args] (apply shs [date args]))


(defn load-deps [file]
  (let [[dir (-> file abspath (splitext) (. [0]))]]
    (for [name (sorted (listdir dir))]
         (if (!= (-> name (splitext) (. [1])) ".hy") (continue))
         (print "Loading" name)
         (try
           (with [[f (open (join dir name))]]
                 (try (while true (eval (read f)))
                      (catch [EOFError])))
           (catch [] (import [traceback])
                     (.print_exc traceback)
                     (print "Failed:" name)))
         (print))))


(with-decorator contextmanager (defn indir [dir]
  (setv popd (getcwd))
  (chdir dir)
  (try (yield)
       (finally
         (chdir popd)))))

(with-decorator contextmanager (defn cdtmp []
  (setv tdir (mkdtemp))
  (try (with [[(indir tdir)]]
             (yield))
       (finally
         (rmtree tdir)))))


(defn prepare-changelog [version suite dcount &optional urgency]
  (let [[dversion (.format "{}-{}~{}1" version dcount suite)]]
    (dch "--newversion" dversion
         "--force-distribution"
         "--distribution" suite
         "--force-bad-version"
         "--urgency" (lif urgency urgency "low")
         "Automated rebuild.")
    dversion))


(defn prepare-source []
  (dpkg-buildpackage "-us" "-uc" "-S" "-nc" "-sa" "-d"))


(defn sign-source [path key]
  (debsign (.format "-k{}" key) path))


(defn repo-clone [url dest &optional refspec]
  (if (.startswith url "svn://")
    (apply svn (flatten [["checkout"]
                         (lif refspec ["-r" refspec] [])
                         [url dest]]))
    (apply git (flatten [["clone"]
                        (lif refspec ["-b" refspec] [])
                        [url dest]]))))


(defn repo-clone-debian [url &optional refspec]
  (setv dest (getcwd))
  (with [[(cdtmp)]]
    (repo-clone url "debian" refspec)
    (setv dcount (with [[(indir "debian")]]
                       (let [[lasttag (gits "describe" "--tags" "--abbrev=0")]
                             [range (+ lasttag "..HEAD")]]
                         (+ 1 (int (gits "rev-list" range "--count"))))))
    (if (exists "./debian/debian/")
        (move "./debian/debian/" dest)
        (move "./debian/" dest))
    dcount))


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
