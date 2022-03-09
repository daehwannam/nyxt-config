
(defmacro comment (&rest args)
  nil)

(progn
  (defvar option-path "~/.config/nyxt/options.lisp")
  (unless (probe-file option-path)
    (with-open-file (f option-path :direction :output)
      (print '(default) f)))
  (defvar machine-options (with-open-file (f option-path) (read f)))
  (defvar machine-config-list
    '((common-data-dir-path
       (my-desktop "~/data/Dropbox/files/nyxt")
       (my-laptop "~/data/Dropbox/files/nyxt"))))

  (defun machine-config-get-all (key)
    (mapcar (lambda (x) (car (cdr x)))
	        (remove-if-not (lambda (x) (member (car x) machine-options))
			               (cdr (assoc key machine-config-list)))))
  (defun machine-config-get-first (key)
    (car (machine-config-get-all key)))

  (defun get-common-data-path (filename)
    (concatenate 'string
                 (machine-config-get-first 'common-data-dir-path)
                 "/" filename)))

(progn
  ;; (remote-execution-p :t) enables to make new nyxt window from command line
  ;; $ nyxt --remote --eval '(make-window)'
  ;;
  ;; (session-restore-prompt :always-restore) automatically restores buffers when nyxt is started
  (define-configuration browser
      ((remote-execution-p :t)
       ;; (session-restore-prompt :always-restore)
       (session-restore-prompt :never-restore))))

(comment
  ;; config examples
  ;; - https://discourse.atlas.engineer/t/my-lightweight-configuration/47
  )

(comment
  ;; to make new nyxt window from command line
  ;; $ nyxt --remote --eval '(make-window)'
  (define-configuration browser ((remote-execution-p :t))))

(progn
  (defvar *my-search-engines*
    (with-open-file (f "/home/dhnam/.config/nyxt/search-engines.lisp") (read f)))

  (defvar *my-default-search-engine-name* "gg"))

(define-configuration buffer
    ;; https://discourse.atlas.engineer/t/how-to-make-my-key-bindings-work-on-the-prompt-buffer-too/206/4
    ;; `no-script-mode' disables JavaScript (https://nyxt.atlas.engineer/documentation)
    ((default-modes (append '(emacs-mode) %slot-default%))

     (override-map (let ((map (make-keymap "my-buffer-override-map")))
                     (define-key map
                       "C-x C-c" 'quit
                       "C-q 8" 'make-window
                       "C-q 0" 'delete-current-window

                       "C-q" 'nothing
                       "C-q b" 'switch-buffer
                       "C-q k" 'delete-buffer
                       "C-q C-k" 'delete-current-buffer
                       "C-q r" 'reopen-buffer
                       "C-q C-r" 'reopen-last-buffer

                       "C-q C-d" 'download-open-file
                       "C-q d" 'list-downloads ; M-D
                       ;; "M-s-D" 'list-downloads       ; M-D

                       "C-M-t" 'nyxt/passthrough-mode:passthrough-mode
                       "C-q C-m" 'nyxt/message-mode:list-messages
                       )))

     ;; the last search engine becomes the default
     (search-engines (append %slot-default%
                             (mapcar (lambda (engine) (apply 'make-search-engine engine))
                                     (append *my-search-engines*
                                             (list (assoc *my-default-search-engine-name*
                                                          *my-search-engines*
                                                          :test #'equal))))))

     ;; (bookmarks-path (make-instance 'bookmarks-data-path
     ;;                                :basename (get-common-data-path "bookmarks.lisp")))
     (bookmarks-file (make-instance 'bookmarks-file
                                    :base-path (get-common-data-path "bookmarks.lisp")))
     ))

(define-configuration nyxt/web-mode:web-mode
    ;; https://discourse.atlas.engineer/t/how-to-make-my-key-bindings-work-on-the-prompt-buffer-too/206/4
    ((default-modes (append '(emacs-mode) %slot-default%))
     ;; (nyxt/web-mode:hints-alphabet "ASDFGHJKL")
     (keymap-scheme
      (define-scheme
          (:name-prefix "my-base" :import %slot-default%)
        scheme:emacs
        (list
         "M-9" 'switch-buffer-previous
         "M-0" 'switch-buffer-next
         "C-9" 'nyxt/web-mode:history-backwards
         "C-0" 'nyxt/web-mode:history-forwards

         ;; "M-x" 'execute-command
         ;; "C-n" 'nyxt/web-mode:scroll-down
         ;; "C-p" 'nyxt/web-mode:scroll-up

         "C-f" 'nyxt/web-mode:scroll-right
         "C-b" 'nyxt/web-mode:scroll-left

         ;; "C-g" 'query-selection-in-search-engine
         ;; "M-s->" 'nyxt/web-mode:scroll-to-bottom
         ;; "M-s-<" 'nyxt/web-mode:scroll-to-top

         "M-f" 'nyxt/input-edit-mode:cursor-forwards-word
         "M-b" 'nyxt/input-edit-mode:cursor-backwards-word
         "C-e" 'nyxt/input-edit-mode:cursor-forwards-word
         "C-a" 'nyxt/input-edit-mode:cursor-backwards-word
         "M-backspace" 'nyxt/input-edit-mode:delete-backwards-word
         "M-d" 'nyxt/input-edit-mode:delete-forwards-word
         "C-q C-w" 'nyxt/web-mode:copy-hint-url

         ;; "M-n" 'nyxt/web-mode:scroll-down
         ;; "M-p" 'nyxt/web-mode:scroll-up

         "C-s" 'nyxt/web-mode:search-buffer
         "M-j" 'nyxt/web-mode:follow-hint-new-buffer-focus
         "M-r" 'nyxt/visual-mode:visual-mode
         "M-e" 'nyxt/input-edit-mode:input-edit-mode
         )))))

(define-configuration nyxt/passthrough-mode:passthrough-mode
    ((keymap-scheme
      (define-scheme "application"
        scheme:cua
        (list
         "C-z" 'nothing
         )))))

(define-configuration (prompt-buffer)
    ((default-modes (append '(emacs-mode) %slot-default%))
     ;; (hide-suggestion-count-p t)
     (override-map (let ((map (make-keymap "my-prompt-buffer-override-map")))
                     (define-key map
                       ;; "C-M-n" 'nyxt/prompt-buffer-mode:scroll-other-buffer-down
                       ;; "C-M-p" 'nyxt/prompt-buffer-mode:scroll-other-buffer-up
                       "M-n" 'nyxt/prompt-buffer-mode:scroll-other-buffer-down
                       "M-p" 'nyxt/prompt-buffer-mode:scroll-other-buffer-up
                       )))))


(progn
  ;; minimum-search-length property is updated for search-buffer
  ;;
  ;; search-buffer is originally defined in "~/common-lisp/nyxt/source/mode/search-buffer.lisp"
  (define-command nyxt/web-mode:search-buffer (&key case-sensitive-p)
    "Search on the current buffer."
    (prompt
     :prompt "Search text"
     :sources (list
               (make-instance 'nyxt/web-mode:user-search-buffer-source
                              :case-sensitive-p case-sensitive-p
                              :minimum-search-length 1 ; updated
                              )))))
