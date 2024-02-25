(define-module (planm packages jvm lsp)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (guix)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))

(define-public kotlin-language-server-bin
  (let* ((base-url "https://github.com/fwcd/kotlin-language-server/releases/download/")
         (version "1.3.9")
         (name "kotlin-language-server-bin")
         (filename "server.zip"))
    (package
     (name name)
     (version version)
     (source (origin
              (method url-fetch)
              (uri (string-append base-url "/" version "/" filename))
              (sha256
               (base32
                "1zjv9w5rc4h8kzgd6xrp5dq22l78dxq2c6w21b92wl6xkkw3hrax"))))
     (inputs (list zip))
     (build-system copy-build-system)
     (synopsis "Kotlin Language Server (binary distribution version)")
     (description "Implementation of the Language Server Protocol for the Kotlin language, from the binary distribution.")
     (home-page "https://github.com/fwcd/kotlin-language-server")
     (license license:cc0))))

kotlin-language-server-bin
