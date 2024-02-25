(define-module (planm packages jvm maven)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (guix)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))

(define-public maven-bin
  (let* ((base-url "https://dlcdn.apache.org/maven/maven-3/")
         (version "3.9.6")
         (name "apache-maven")
         (filebasename (string-append name "-" version))
         (filename (string-append filebasename "-bin.tar.gz")))
    (package
     (name name)
     (version version)
     (source (origin
              (method url-fetch)
              (uri (string-append base-url "/" version "/binaries/" filename))
              (sha256
               (base32
                "0jrs1h7bsm878crz01vz55j3v1b5s95k5vn9lp9nlvb2wg5d5vbf"))))
     (build-system copy-build-system)
     (synopsis "Apache Maven build system (binary distribution version)")
     (description "Apache Maven build system from the binary distribution.")
     (home-page "https://maven.apache.org/")
     (license license:apsl2))))
