(define-module (planm packages jvm clojure)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages java)
  #:use-module (guix)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))

(define-public clojure-tools
  (let* ((v "1.11.1.1435")
         (base-url "https://github.com/clojure/brew-install/releases/download/")
         (download-url (string-append base-url v "/clojure-tools-" v ".tar.gz"))
         )
    (package
     (name "clojure-tools")
     (version v)
     (source
      (origin
       (method url-fetch)
       (uri download-url)
       (sha256 (base32 "1h4v762agzhnrqs3mj7a84xlw51xv6jh8mvlc5cc83q4n9wwabs5"))
       ;; Remove AOT compiled JAR.  The other JAR only contains uncompiled
       ;; Clojure source code.
       (snippet
        `(delete-file ,(string-append "clojure-tools-" version ".jar")))))
     (build-system copy-build-system)
     (arguments
      `(#:install-plan
        '(("deps.edn" "lib/clojure/")
          ("example-deps.edn" "lib/clojure/")
          ("tools.edn" "lib/clojure/")
          ("exec.jar" "lib/clojure/libexec/")
          ("clojure" "bin/")
          ("clj" "bin/"))
        #:modules ((guix build copy-build-system)
                   (guix build utils)
                   (srfi srfi-1)
                   (ice-9 match))
        #:phases
        (modify-phases %standard-phases
                       (add-after 'unpack 'fix-paths
                                  (lambda* (#:key outputs #:allow-other-keys)
                                    (substitute* "clojure"
                                                 (("PREFIX") (string-append (assoc-ref outputs "out") "/lib/clojure")))
                                    (substitute* "clj"
                                                 (("BINDIR") (string-append (assoc-ref outputs "out") "/bin"))
                                                 (("rlwrap") (which "rlwrap")))))
                       (add-after 'fix-paths 'copy-tools-deps-alpha-jar
                                  (lambda* (#:key inputs outputs #:allow-other-keys)
                                    (substitute* "clojure"
                                                 (("\\$install_dir/libexec/clojure-tools-\\$version\\.jar")
                                                  (string-join
                                                   (append-map (match-lambda
                                                                 ((label . dir)
                                                                  (find-files dir "\\.jar$")))
                                                               inputs)
                                                   ":"))))))))
     (inputs (list rlwrap
                   openjdk))
     (home-page "https://clojure.org/releases/tools")
     (synopsis "CLI tools for the Clojure programming language")
     (description "The Clojure command line tools can be used to start a
Clojure repl, use Clojure and Java libraries, and start Clojure programs.")
     (license license:epl1.0))))
