;; よく使うコマンド
;; C-l   : analytingでファイル検索
;; C-x u : undo-tree-visualize


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 基本設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 文字化け対策
(setq locale-coding-system 'utf-8)

;;  which will automatically revert your files to what's on disk.
(global-auto-revert-mode)

;; before-save-hook
;;-----------------
;; 行末の空白を削除する
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 行末の空白に色をつける
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))

(set-face-background 'trailing-whitespace "purple4")

;; 文字列を折り返さない設定
(setq-default truncate-lines t)                 ;;通常のウィンドウ用の設定
(setq-default truncate-partial-width-windows t) ;;ウィンドウを左右に分割したとき用の設定

;; Macの文字コードの設定
(set-language-environment "Japanese")
(require 'ucs-normalize)
(prefer-coding-system 'utf-8)
(setq file-name-doding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)

;; 環境変数パスを設定
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/opt/local/bin"
              "/sw/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              (expand-file-name "~/.rbenv/shims/")
              ))
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

;; C-kで行全体を削除
(setq kill-whole-line t)

;; cuamode
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; そのままだと C-x が切り取りになってしまったりするので無効化

;; exec-pathリストにパスを追加する
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/opt/local/sbin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/local/sbin")
(add-to-list 'exec-path "~/bin")

;; 環境変数 PATH に exec-path を追加する。
(setenv "PATH" (mapconcat 'identity exec-path ":"))

;;; 不要なものを非表示にする
;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)
(when window-system
  ;; tool-bar を非表示
  (tool-bar-mode 0)
  ;; scroll-bar を非表示
  (scroll-bar-mode 0))
;; カーソルを点滅
(blink-cursor-mode t)
;; menu-bar を非表示
;;(menu-bar-mode 0)

;;; 情報を表示する、目立たせる
;; メニューバーにファイルのフルパスを表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; paren: 対応する括弧を光らせる
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)                    ; カッコ内の色も変更
(set-face-background 'show-paren-match-face nil)       ; カッコ内のフェイス
(set-face-underline-p 'show-paren-match-face "yellow") ; カッコ内のフェイス

;; 改行時にインデントする
(global-set-key "\C-m" 'newline-and-indent)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elips
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
          (normal-top-level-add-subdirs-to-load-path))))))

;; elispとconfディレクトリをサブディレクトリごとにload-pathに追加
(add-to-load-path "elisp" "conf")

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する 初期値は ~/.emacs.d/elisp/")
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されている elisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elispの関数を利用可能にする
  (auto-install-compatibility-setup))

;;;; packageを追加
;;(require 'package)
;;(add-to-list 'package-archives
;;    '("marmalade" .
;;          "http://marmalade-repo.org/packages/"))
;;          (package-initialize)
;;
;;;; markdown
;;(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;;(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;;
;;;;(defun markdown-custom ()
;;;;  "markdown-mode-hook"
;;;;    (setq markdown-command "redcarpet"))
;;;;    (add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))

;; grep-find
(defadvice grep-find (around inhibit-read-only activate)
  ""
  (let ((inhibit-read-only t))
    ad-do-it))

;; grep-edit
(require 'grep)
(require 'grep-edit)

(defadvice grep-edit-change-file (around inhibit-read-only activate)
  ""
  (let ((inhibit-read-only t))
    ad-do-it))
;; (progn (ad-disable-advice 'grep-edit-change-file 'around 'inhibit-read-only) (ad-update 'grep-edit-change-file))

(defun my-grep-edit-setup ()
  (define-key grep-mode-map '[up] nil)
  (define-key grep-mode-map "\C-c\C-c" 'grep-edit-finish-edit)
  (message (substitute-command-keys "\\[grep-edit-finish-edit] to apply changes."))
  (set (make-local-variable 'inhibit-read-only) t)
  )
(add-hook 'grep-setup-hook 'my-grep-edit-setup t)

;; インデントの設定
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)
(setq java-indent-level 2)
(setq java-indent-tabs-mode nil)
(setq js-indent-level 2)
(setq cperl-indent-level 2)
(setq php-indent-level 4)

;; beep音を消す
(setq visible-bell t)

;; バックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-inhibited t)

;; color-moccur: 検索結果をリストアップ
;; (install-elisp "http://www.emacswiki.org/emacs/download/color-moccur.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/moccur-edit.el")
;; -------------------------------------------------------------------------
(when (require 'color-moccur nil t)
  ;; グローバルマップにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (require 'moccur-edit nil t)
  ;; migemo 利用できる環境であれば migemo を使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))


;;; migemo: ローマ字インクリメンタルサーチ
;; (auto-install-from-gist "457761")
;; -------------------------------------------------------------------------
(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  ;; cmigemoを使う
  (setq migemo-command "cmigemo")
  ;; migemoのコマンドラインオプション
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  ;; migemo辞書の場所
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  ;; cmigemoで必須の設定
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  ;; キャッシュの設定
  (setq migemo-use-pattern-alist t)
  (setq migemo-use-frequent-pattern-alist t)
  (setq migemo-pattern-alist-length 1000)
  (setq migemo-coding-system 'utf-8-unix)
  ;; migemoを起動する
  (migemo-init))

;; redo+.el
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;; -------------------------------------------------------------------------
(when (require 'redo+ nil t)
  ;; global-map
  (global-set-key (kbd "C-'") 'redo))

;;; undohist: 閉じたバッファも Undo できる
;; (install-elisp "http://cx4a.org/pub/undohist.el")
;; -------------------------------------------------------------------------
(when (require 'undohist nil t)
  (undohist-initialize))

;;; undo-tree: Undo の分岐を視覚化する
;; (install-elisp "http://www.dr-qubit.org/undo-tree/undo-tree.el")
;; -------------------------------------------------------------------------
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;; point-undo: カーソル位置を Undo
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el")
(when (require 'point-undo nil t)
;; -------------------------------------------------------------------------
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo))

;;; wdiree: dired で直接ファイルをリネーム
;; -------------------------------------------------------------------------
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; php-mode
;; (install-elisp "http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/php-mode.el")
;; ------------------------------------------------------------------------
(require 'php-mode)

(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;*.phpのファイルのときにphp-modeを自動起動する

;; php-completion
;; M-x auto-install-batchでphp-completionを選択
;; ------------------------------------------------------------------------
;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
	    (php-completion-mode t)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))

;; ------------------------------------------------------------------------
;; auto-complete-mode: 高機能補完+ポップアップメニュー
;; -------------------------------------------------------------------------
 (when (require 'auto-complete-config nil t)
   (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
   (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
   (ac-config-default))

   (add-hook 'coffee-mode-hook
     '(lambda ()
       (add-to-list 'ac-dictionary-files "~/.emacs.d/elisp/ac-dict/javascript-mode")
       ))

   (add-hook 'java-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq c-basic-offset 2)))

   (add-hook 'php-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq c-basic-offset 4)))

  (add-to-list 'ac-modes 'fundamental-mode)
  (add-to-list 'ac-modes 'coffee-mode)


;;; smartchr: サイクルスニペット
;; (install-elisp "http://github.com/imakado/emacs-smartchr/raw/master/smartchr.el")
;; -------------------------------------------------------------------------
(when (require 'smartchr nil t)
  (define-key global-map (kbd "=") (smartchr '("=" " = " " == " " === ")))
  (defun css-mode-hooks ()
    (define-key cssm-mode-map (kbd ":") (smartchr '(": " ":"))))

  (add-hook 'css-mode-hook 'css-mode-hooks))

;;; Elscreen: GNU Screenライクなウィンドウ管理を実現
;; -------------------------------------------------------------------------
(when (require 'elscreen nil t)
  (if window-system
      (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
    (define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

;;; Anything
;; M-x auto-install-batch anything
;; -------------------------------------------------------------------------
(require 'anything)
(require 'anything-startup)

;; https://code.google.com/p/emacs-nav/
;; -------------------------------------------------------------------------
(require 'nav)
(global-set-key "\C-x\C-d" 'nav-toggle)

;; (M-x package-install coffee-mode
;; -------------------------------------------------------------------------
;;(require 'coffee-mode)
;;(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
;;(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2)
 (setq coffee-tab-width 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;; (install-elisp "http://www.emacswiki.org/emacs/download/multi-term.el")
;; -------------------------------------------------------------------------
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/bash"))

;;(autoload 'html-helper-mode "html-helper-mode" "Yay HTML")
;;(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode)       auto-mode-alist))
;;(setq auto-mode-alist (cons '("\\.jst$" . html-helper-mode)      auto-mode-alist))
;;(setq auto-mode-alist (cons '("\\.erb$" . html-helper-mode)      auto-mode-alist))
;;(setq auto-mode-alist (cons '("\\.ejs$" . html-helper-mode)      auto-mode-alist))

;; ruby-mode, rbファイルの関連付け
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
  '(lambda ()
  (inf-ruby-keys)
  (add-to-list 'ruby-encoding-map '(utf-8-hfs . utf-8))
))

;; ruby-electric
;; -------------------------------------------------------------------------
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; ruby-block
;; (install-elisp "http://www.emacswiki.org/emacs/download/ruby-block.el")
;; -------------------------------------------------------------------------
(require 'ruby-block)
;; rblockを有効にすると#{}が入力出来ない
(ruby-block-mode t)
;; ミニバッファに表示し, かつ, オーバレイする.
(setq ruby-block-highlight-toggle t)


;; (install-elisp "https://raw.github.com/byplayer/egg/master/egg.el")
(when (executable-find "git")
  (require 'egg nil t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-l") 'anything-for-files)  ; anythingでファイルを切り替える
(global-set-key (kbd "s-n") 'other-window)        ; 次のwindowに移動
(global-set-key (kbd "s-p") 'back-window)         ; 前のwindowに移動
(global-set-key (kbd "M-o") 'edit-next-line)      ; vimのoコマンド(次の行に挿入)
(global-set-key (kbd "M-O") 'edit-previous-line)  ; vimのOコマンド(前の行に挿入)
(global-set-key (kbd "M-l") 'forward-match-char)  ; vimのfコマンド(後方の入力した文字の上に移動)
(global-set-key (kbd "M-L") 'backward-match-char) ; vimのFコマンド(前方の入力した文字の上に移動)

;;
;; vimっぽい設定
;; -------------------------------------------

;; 'o' 次の行に挿入
(defun edit-next-line ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

;; 'O' 前の行に挿入
(defun edit-previous-line ()
  (interactive)
  (forward-line -1)
  (if (not (= (current-line) 1))
      (end-of-line))
  (newline-and-indent))

;; 'f' 後方の入力した文字の上に移動
(defun forward-match-char (n)
  (interactive "p")
  (let ((c (read-char)))
    (dotimes (i n)
      (forward-char)
      (skip-chars-forward (format "^%s" (char-to-string c))))))

;; 'F' 前方の入力した文字の上に移動
(defun backward-match-char (n)
  (interactive "p")
  (let ((c (read-char)))
    (dotimes (i n)
      (skip-chars-backward (format "^%s" (char-to-string c)))
      (backward-char))))

;; 前のwindowに移動
(defun back-window ()
  (interactive)
  (other-window -1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 拡張子とモードの紐付け
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.god" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.shoes" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 表示設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 行番号を表示する
(global-linum-mode)
;; タブを使用せずにスペースを利用する
(setq-default indent-tabs-mode nil)

;; Font
(when (>= emacs-major-version 23)
 (set-face-attribute 'default nil
                     :family "monaco"
                     :height 120)
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0208
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'mule-unicode-0100-24ff
  '("monaco" . "iso10646-1"))
 (setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gosh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Gaucheのデフォルトエンコーディングに合わせます。

;; してください。
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))
;; goshインタプリタのパスに合わせます。-iは対話モードを意味します。
(setq gosh-program-name "/usr/local/bin/gosh -i")
;; schemeモードとrun-schemeモードにcmuscheme.elを使用します。
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)
;; ウィンドウを2つに分け、一方でgoshインタプリタを実行するコマンドを定義します。
(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme gosh-program-name))
;; そのコマンドをCtrl-csで呼び出します。
(define-key global-map
  "\C-cs" 'scheme-other-window)

;; 直前/直後の括弧に対応する括弧を光らせます。
(show-paren-mode)

;; 以下はインデントの定義です。
(put 'and-let* 'scheme-indent-function 1)
(put 'begin0 'scheme-indent-function 0)
(put 'call-with-client-socket 'scheme-indent-function 1)
(put 'call-with-input-conversion 'scheme-indent-function 1)
(put 'call-with-input-file 'scheme-indent-function 1)
(put 'call-with-input-process 'scheme-indent-function 1)
(put 'call-with-input-string 'scheme-indent-function 1)
(put 'call-with-iterator 'scheme-indent-function 1)
(put 'call-with-output-conversion 'scheme-indent-function 1)
(put 'call-with-output-file 'scheme-indent-function 1)
(put 'call-with-output-string 'scheme-indent-function 0)
(put 'call-with-temporary-file 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 1)
(put 'dolist 'scheme-indent-function 1)
(put 'dotimes 'scheme-indent-function 1)
(put 'if-match 'scheme-indent-function 2)
(put 'let*-values 'scheme-indent-function 1)
(put 'let-args 'scheme-indent-function 2)
(put 'let-keywords* 'scheme-indent-function 2)
(put 'let-match 'scheme-indent-function 2)
(put 'let-optionals* 'scheme-indent-function 2)
(put 'let-syntax 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'let/cc 'scheme-indent-function 1)
(put 'let1 'scheme-indent-function 2)
(put 'letrec-syntax 'scheme-indent-function 1)
(put 'make 'scheme-indent-function 1)
(put 'multiple-value-bind 'scheme-indent-function 2)
(put 'match 'scheme-indent-function 1)
(put 'parameterize 'scheme-indent-function 1)
(put 'parse-options 'scheme-indent-function 1)
(put 'receive 'scheme-indent-function 2)
(put 'rxmatch-case 'scheme-indent-function 1)
(put 'rxmatch-cond 'scheme-indent-function 0)
(put 'rxmatch-if  'scheme-indent-function 2)
(put 'rxmatch-let 'scheme-indent-function 2)
(put 'syntax-rules 'scheme-indent-function 1)
(put 'unless 'scheme-indent-function 1)
(put 'until 'scheme-indent-function 1)
(put 'when 'scheme-indent-function 1)
(put 'while 'scheme-indent-function 1)
(put 'with-builder 'scheme-indent-function 1)
(put 'with-error-handler 'scheme-indent-function 0)
(put 'with-error-to-port 'scheme-indent-function 1)
(put 'with-input-conversion 'scheme-indent-function 1)
(put 'with-input-from-port 'scheme-indent-function 1)
(put 'with-input-from-process 'scheme-indent-function 1)
(put 'with-input-from-string 'scheme-indent-function 1)
(put 'with-iterator 'scheme-indent-function 1)
(put 'with-module 'scheme-indent-function 1)
(put 'with-output-conversion 'scheme-indent-function 1)
(put 'with-output-to-port 'scheme-indent-function 1)
(put 'with-output-to-process 'scheme-indent-function 1)
(put 'with-output-to-string 'scheme-indent-function 1)
(put 'with-port-locking 'scheme-indent-function 1)
(put 'with-string-io 'scheme-indent-function 1)
(put 'with-time-counter 'scheme-indent-function 1)
(put 'with-signal-handlers 'scheme-indent-function 1)
(put 'with-locking-mutex 'scheme-indent-function 1)
(put 'guard 'scheme-indent-function 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wheatgrass))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
