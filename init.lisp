
;; (progn
;;   ;; allow multiple instances of Nyxt
;;   ;; https://discourse.atlas.engineer/t/my-lightweight-configuration/47
;;   (setf *socket-path* nil))

(define-configuration web-buffer
    ;; https://discourse.atlas.engineer/t/my-lightweight-configuration/47
    ((default-modes (append '(auto-mode emacs-mode) %slot-default%))
     (override-map (let ((map (make-keymap "my-override-map")))
                     (define-key map
                       "C-q" 'quit
                       "C-8" 'make-window
                       "C-0" 'delete-current-window)
                     map))))

(when nil
  (define-command-global scroll-small-page-down ()
    "Scroll down by a small height."
    (pflet ((scroll-page-down ()
                              (ps:chain window (scroll-by 0 30))))
           (scroll-page-down)))

  (define-command-global scroll-small-page-up ()
    "Scroll up by a small height."
    (pflet ((scroll-page-up ()
                            (ps:chain window (scroll-by 0 -30))))
           (scroll-page-up)))

  (define-configuration buffer
      ((override-map (let ((map (make-keymap "my-override-map")))
                       (define-key map "M-n" 'scroll-small-page-down)
                       (define-key map "M-p" 'scroll-small-page-up)
                       map)))))

(progn
  (define-configuration buffer
      ;; https://discourse.atlas.engineer/t/how-to-make-my-key-bindings-work-on-the-prompt-buffer-too/206/4
      ((override-map (let ((map (make-keymap "override-map")))
                       (define-key map
                         "M-x" 'execute-command
                         "C-n" 'nyxt/web-mode:scroll-down
                         "C-p" 'nyxt/web-mode:scroll-up
                         "C-f" 'nyxt/web-mode:scroll-right
                         "C-b" 'nyxt/web-mode:scroll-left
                         "C-g" 'query-selection-in-search-engine
                         "M-s->" 'nyxt/web-mode:scroll-to-bottom
                         "M-s-<" 'nyxt/web-mode:scroll-to-top
                         "C-s" 'nyxt/web-mode:search-buffer)))))

  (define-configuration (prompt-buffer)
      ((default-modes (append '(emacs-mode) %slot-default%))
       (hide-suggestion-count-p t))))
