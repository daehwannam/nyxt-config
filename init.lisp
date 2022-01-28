
;; (progn
;;   ;; allow multiple instances of Nyxt
;;   ;; https://discourse.atlas.engineer/t/my-lightweight-configuration/47
;;   (setf *socket-path* nil))

(defmacro comment (&rest args)
  nil)

(progn
  ;; (remote-execution-p :t) enable to make new nyxt window from command line
  ;; $ nyxt --remote --eval '(make-window)'
  ;;
  ;; (session-restore-prompt :always-restore) automatically restores buffers when nyxt is started
  (define-configuration browser
      ((remote-execution-p :t)
       (session-restore-prompt :always-restore)
       ;; (session-restore-prompt :never-restore)
       )))

(comment
  ;; to make new nyxt window from command line
  ;; $ nyxt --remote --eval '(make-window)'
 (define-configuration browser ((remote-execution-p :t))))

(comment
 (define-configuration nyxt/web-mode:web-mode
     ;; QWERTY home row.
     ((nyxt/web-mode:hints-alphabet "ASDFGHJKL"))))

(comment
 (define-configuration web-buffer
     ;; https://discourse.atlas.engineer/t/my-lightweight-configuration/47
     ((default-modes (append '(auto-mode emacs-mode) %slot-default%)))))

(comment
 (define-configuration web-buffer
     ;; https://discourse.atlas.engineer/t/my-lightweight-configuration/47
     ((default-modes (append '(auto-mode emacs-mode) %slot-default%))
      (override-map (let ((map (make-keymap "my-web-buffer-override-map")))
                      (define-key map
                        "C-4" 'quit
                        "C-8" 'make-window
                        "C-0" 'delete-current-window
                        "M-n" 'nyxt/web-mode:scroll-down
                        "M-p" 'nyxt/web-mode:scroll-up
                        )
                      map)))))

(comment
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
     ((default-modes (append '(nyxt::emacs-mode) %slot-default%))
      (override-map (let ((map (make-keymap "my-override-map")))
                      (define-key map "M-n" 'scroll-small-page-down)
                      (define-key map "M-p" 'scroll-small-page-up)
                      map)))))

(defvar *my-search-engines*
  ;; https://github.com/atlas-engineer/nyxt/issues/1554#issuecomment-868443403
  ;; https://discourse.atlas.engineer/t/search-engine-help/190
  (list
   '("gg" "https://www.google.com/search?q=~a" "https://www.google.com/")
   '("quickdocs" "http://quickdocs.org/search?q=~a" "http://quickdocs.org/")
   '("wiki" "https://en.wikipedia.org/w/index.php?search=~a" "https://en.wikipedia.org/")
   '("define" "https://en.wiktionary.org/w/index.php?search=~a" "https://en.wiktionary.org/")
   '("python3" "https://docs.python.org/3/search.html?q=~a" "https://docs.python.org/3")
   '("doi" "https://dx.doi.org/~a" "https://dx.doi.org/")))

(define-configuration buffer
    ;; https://discourse.atlas.engineer/t/how-to-make-my-key-bindings-work-on-the-prompt-buffer-too/206/4
    ((default-modes (append '(auto-mode emacs-mode) %slot-default%))
     ;; (nyxt/web-mode:hints-alphabet "ASDFGHJKL")
     (override-map (let ((map (make-keymap "my-buffer-override-map")))
                     (define-key map
                       ;; "M-x" 'execute-command
                       ;; "C-n" 'nyxt/web-mode:scroll-down
                       ;; "C-p" 'nyxt/web-mode:scroll-up
                       ;; "C-f" 'nyxt/web-mode:scroll-right
                       ;; "C-b" 'nyxt/web-mode:scroll-left
                       ;; "C-g" 'query-selection-in-search-engine
                       ;; "M-s->" 'nyxt/web-mode:scroll-to-bottom
                       ;; "M-s-<" 'nyxt/web-mode:scroll-to-top

                       "C-4" 'quit
                       "C-8" 'make-window
                       "C-0" 'delete-current-window

                       "C-q" 'nothing
                       "C-q b" 'switch-buffer

                       "M-n" 'nyxt/web-mode:scroll-down
                       "M-p" 'nyxt/web-mode:scroll-up

                       "C-s" 'nyxt/web-mode:search-buffer
                       "M-j" 'nyxt/visual-mode:visual-mode
                       )))

     (search-engines (append (mapcar (lambda (engine) (apply 'make-search-engine engine))
                                     *my-search-engines*)
                             %slot-default%))

     ;; (bookmarks-path (make-instance 'bookmarks-data-path
     ;;                                :basename "~/personal/bookmarks/bookmarks.lisp"))
     ))

(define-configuration (prompt-buffer)
    ((default-modes (append '(emacs-mode) %slot-default%))
     (hide-suggestion-count-p t)
     (override-map (let ((map (make-keymap "my-buffer-override-map")))
                     (define-key map
                       "M-n" 'nyxt/web-mode:scroll-down
                       "M-p" 'nyxt/web-mode:scroll-up
                       )))))
