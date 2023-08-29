(define-module (tminor-guix packages exwm-gdm)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system copy))

(define-public exwm-gdm
  (package
    (name "exwm-gdm")
    (version "0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Koekelas/exwm-gdm")
             (commit "ec3a59a366078b1e8994c23fadb6e19146c154ec")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "03qxdhyi2119dvk2gv0gw0k835iaixi8w67lqwv5nbp42qn3bcp6"))))
    (build-system copy-build-system)
    (arguments
      `(#:install-plan
        '(("exwm.desktop" "share/xsessions/exwm.desktop")
          ("exwm" "bin/exwm"))))
    (synopsis "Supporting configuration for launching EXWM via GDM.")
    (description "Starts EXWM via GDM.")
    (home-page "https://github.com/Koekelas/exwm-gdm")
    (license license:gpl3)))
