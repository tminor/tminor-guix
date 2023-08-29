(define-module (tminor-guix home-services desktop)
  #:use-module (gnu home services)
  #:use-module (gnu home services utils)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xfce)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu services configuration)

  #:use-module (srfi srfi-1)

  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)

  #:use-module (tminor-guix packages exwm-gdm)

  #:export (home-exwm-configuration
            home-exwm-service-type))

(define-configuration home-exwm-configuration
  (package
   (package exwm-gdm)
   "The exwm-gdm package to use.")
  (exwmrc-head
   (text-config '())
   "List of strings or gexps for the head of the EXWM config file.")
  (exwmrc-tail
   (text-config '())
   "List of strings or gexps for the tail of the EXWM config file."))

(define (add-exwm-package config)
  (list (home-exwm-configuration-package config)))

(define (add-exwm-files config)
  `((".config/exwmrc" ,(mixed-executable-text-file
                         "exwmrc"
                         (serialize-configuration
                          config
                          (filter-configuration-fields
                           home-exwm-configuration-fields
                           '(exwmrc-head
                             exwmrc-tail)))))))

(define (add-exwmrc-extensions config extensions)
  (home-exwm-configuration
   (inherit config)
   (exwmrc-head
    (append (home-exwm-configuration-exwmrc-head config)
            extensions))))

(define home-exwm-service-type
  (service-type (name 'home-exwm)
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        add-exwm-package)
                       (service-extension
                        home-files-service-type
                        add-exwm-files)))
                (compose concatenate)
                (extend add-exwmrc-extensions)
                (default-value (home-exwm-configuration))
                (description "Install and configure EXWM.")))
