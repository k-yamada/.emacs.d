<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: grep-a-lot.el</title><link rel="alternate" type="application/wiki" title="Edit this page" href="http://www.emacswiki.org/emacs?action=edit;id=grep-a-lot.el" /><link type="text/css" rel="stylesheet" href="/emacs/wiki.css" /><meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="http://www.emacswiki.org/emacs?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: grep-a-lot.el" href="http://www.emacswiki.org/emacs?action=rss;rcidonly=grep-a-lot.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="http://www.emacswiki.org/emacs/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="http://www.emacswiki.org/emacs/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="http://www.emacswiki.org/emacs/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for grep-a-lot.el only"
      href="http://www.emacswiki.org/emacs?action=rss;rcidonly=grep-a-lot.el" />
<script type="text/javascript" src="/outliner.0.5.0.62-toc.js"></script>
<script type="text/javascript">

  function addOnloadEvent(fnc) {
    if ( typeof window.addEventListener != "undefined" )
      window.addEventListener( "load", fnc, false );
    else if ( typeof window.attachEvent != "undefined" ) {
      window.attachEvent( "onload", fnc );
    }
    else {
      if ( window.onload != null ) {
	var oldOnload = window.onload;
	window.onload = function ( e ) {
	  oldOnload( e );
	  window[fnc]();
	};
      }
      else
	window.onload = fnc;
    }
  }

  var initToc=function() {

    var outline = HTML5Outline(document.body);
    if (outline.sections.length == 1) {
      outline.sections = outline.sections[0].sections;
    }

    if (outline.sections.length > 1
	|| outline.sections.length == 1
           && outline.sections[0].sections.length > 0) {

      var toc = document.getElementById('toc');

      if (!toc) {
	var divs = document.getElementsByTagName('div');
	for (var i = 0; i < divs.length; i++) {
	  if (divs[i].getAttribute('class') == 'toc') {
	    toc = divs[i];
	    break;
	  }
	}
      }

      if (!toc) {
	var h2 = document.getElementsByTagName('h2')[0];
	if (h2) {
	  toc = document.createElement('div');
	  toc.setAttribute('class', 'toc');
	  h2.parentNode.insertBefore(toc, h2);
	}
      }

      if (toc) {
        var html = outline.asHTML(true);
        toc.innerHTML = html;
      }
    }
  }

  addOnloadEvent(initToc);
  </script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body class="http://www.emacswiki.org/emacs"><div class="header"><a class="logo" href="http://www.emacswiki.org/emacs/SiteMap"><img class="logo" src="/emacs_logo.png" alt="[Home]" /></a><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span>
<!-- Google CSE Search Box Begins  -->
<form class="tiny" action="http://www.google.com/cse" id="searchbox_004774160799092323420:6-ff2s0o6yi"><p>
<input type="hidden" name="cx" value="004774160799092323420:6-ff2s0o6yi" />
<input type="text" name="q" size="25" />
<input type="submit" name="sa" value="Search" />
</p></form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_004774160799092323420%3A6-ff2s0o6yi"></script>
<!-- Google CSE Search Box Ends -->
<h1><a title="Click to search for references to this page" rel="nofollow" href="http://www.google.com/cse?cx=004774160799092323420:6-ff2s0o6yi&amp;q=%22grep-a-lot.el%22">grep-a-lot.el</a></h1></div><div class="wrapper"><div class="wrapper"><div class="content browse"><p class="download"><a href="http://www.emacswiki.org/emacs/download/grep-a-lot.el">Download</a></p><pre class="code"><span class="linecomment">;;; grep-a-lot.el --- manages multiple search results buffers for grep.el</span>

<span class="linecomment">;; Copyright (C) 2008-2012 Avi Rozen</span>

<span class="linecomment">;; Author: Avi Rozen &lt;avi.rozen@gmail.com&gt;</span>
<span class="linecomment">;; Keywords: tools, convenience, search</span>
<span class="linecomment">;; URL: https://github.com/ZungBang/emacs-grep-a-lot</span>
<span class="linecomment">;; Version: 1.0.6</span>

<span class="linecomment">;; This file is NOT part of GNU Emacs.</span>

<span class="linecomment">;; This program is free software; you can redistribute it and/or modify</span>
<span class="linecomment">;; it under the terms of the GNU General Public License as published by</span>
<span class="linecomment">;; the Free Software Foundation; either version 3, or (at your option)</span>
<span class="linecomment">;; any later version.</span>

<span class="linecomment">;; This program is distributed in the hope that it will be useful,</span>
<span class="linecomment">;; but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span>
<span class="linecomment">;; GNU General Public License for more details.</span>

<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with this program; see the file COPYING.  If not, write to the</span>
<span class="linecomment">;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,</span>
<span class="linecomment">;; Boston, MA 02110-1301, USA.</span>

<span class="linecomment">;;; Commentary:</span>

<span class="linecomment">;; This package manages multiple search results buffers:</span>
<span class="linecomment">;; - the search results of grep, lgrep, rgrep, and find-grep are sent</span>
<span class="linecomment">;;   to separate buffers instead of overwriting the contents of a single</span>
<span class="linecomment">;;   buffer (buffers are named *grep*&lt;N&gt; where N is a number)</span>
<span class="linecomment">;; - several navigation functions are provided to allow the user to treat</span>
<span class="linecomment">;;   the search results buffers as a stack and/or ring, and to easily reset</span>
<span class="linecomment">;;   the state of each search buffer after navigating through the results</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Installation:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 1. Put this file in a directory that is a member of load-path, and</span>
<span class="linecomment">;;    byte-compile it (e.g. with `M-x byte-compile-file') for better</span>
<span class="linecomment">;;    performance.</span>
<span class="linecomment">;; 2. Add the following to your ~/.emacs:</span>
<span class="linecomment">;;    (require 'grep-a-lot)</span>
<span class="linecomment">;;    (grep-a-lot-setup-keys)</span>
<span class="linecomment">;; 3. If you're using igrep.el you may want to add:</span>
<span class="linecomment">;;    (grep-a-lot-advise igrep)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Currently, there are no customization options.</span>
<span class="linecomment">;;    </span>
<span class="linecomment">;; Default Key Bindings:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Ring navigation:</span>
<span class="linecomment">;; M-g ]         Go to next search results buffer, restore its current search context</span>
<span class="linecomment">;; M-g [         Ditto, but selects previous buffer.</span>
<span class="linecomment">;;               Navigation is cyclic.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Stack navigation:</span>
<span class="linecomment">;; M-g -         Pop to previous search results buffer (kills top search results buffer)</span>
<span class="linecomment">;; M-g _         Clear the search results stack (kills all grep-a-lot buffers!)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Other:</span>
<span class="linecomment">;; M-g =         Restore buffer and position where current search started</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Code:</span>

(require 'advice)
(require 'grep)

(defconst grep-a-lot-buffer-name-regexp "<span class="quote">^\\*grep\\*&lt;\\([0-9]+\\)&gt;$</span>"
  "<span class="quote">Buffer name regular expression for extracting stack position.</span>")

(defvar grep-a-lot-is-current-buffer nil
  "<span class="quote">Default value for buffer local variable `grep-a-lot-is-current-buffer'.</span>")

(defvar grep-a-lot-context-initial nil
  "<span class="quote">Default value for buffer local variable `grep-a-lot-context-initial'.</span>")

(defvar grep-a-lot-context nil
  "<span class="quote">Default value for buffer local variable `grep-a-lot-context'.</span>")

(defun grep-a-lot-buffer-p (&optional buffer)
  "<span class="quote">Return non-nil if BUFFER is a grep-a-lot search result buffer.
The buffer name must match `grep-a-lot-buffer-name-regexp'.
With no argument or nil as argument, check current buffer.</span>"
  (let ((name (buffer-name buffer)))
    (if (string-match grep-a-lot-buffer-name-regexp name)
        (get-buffer name)
      nil)))

(defun grep-a-lot-current-buffer-p (&optional buffer)
  "<span class="quote">Return non-nil if BUFFER is the current grep-a-lot search result buffer.
With no argument or nil as argument, check current buffer.</span>"
  (let ((buffer (grep-a-lot-buffer-p buffer)))
    (if buffer
        (save-excursion
          (set-buffer buffer)
          (if grep-a-lot-is-current-buffer
              buffer
            nil))
      nil)))

(defun grep-a-lot-buffers (&optional reverse)
  "<span class="quote">Return a sorted list of grep-a-lot search result buffers.
With REVERSE non-nil the sort order is reversed.</span>"
  (let* ((buffers nil)
         (all-buffers (buffer-list)))
    <span class="linecomment">;; filter out non grep-a-lot buffers</span>
    (while all-buffers
      (let ((buffer (car all-buffers)))
        (if (grep-a-lot-buffer-p buffer)
            (setq buffers (append buffers (list buffer))))
        (setq all-buffers (cdr all-buffers))))
    <span class="linecomment">;; sort buffers</span>
    (sort buffers (lambda (a b)
                    (let ((pos-a (grep-a-lot-buffer-position (buffer-name a)))
                          (pos-b (grep-a-lot-buffer-position (buffer-name b))))
                      (if reverse
                          <span class="linecomment">;; assume pos-a and pos-b are not equal</span>
                          (&lt; pos-b pos-a)
                        (&lt; pos-a pos-b)))))))

(defun grep-a-lot-last-buffer ()
  "<span class="quote">Return last grep-a-lot buffer.</span>"
  (car (last (grep-a-lot-buffers))))

(defun grep-a-lot-get-current-buffer (&optional buffers)
  "<span class="quote">Returns the current search results buffer, from the list BUFFERS.
Returns nil if no such buffer exists.
BUFFERS can either be a list generated by `grep-a-lot-buffers' or nil,
in which case the list of buffers to consider is generated by `grep-a-lot-buffers'.</span>"
  (let ((current nil)
        (buffers (or buffers (grep-a-lot-buffers))))
    (while buffers
      (if (grep-a-lot-current-buffer-p (car buffers))
          (setq current (car buffers)
                buffers nil)
        (setq buffers (cdr buffers))))
    current))

(defun grep-a-lot-set-current-buffer (&optional current-buffer)
  "<span class="quote">Set CURRENT-BUFFER as current search results buffer.
If CURRENT-BUFFER is not specified or is nil, then use current buffer.</span>"
  (let ((buffers (grep-a-lot-buffers))
        (current-buffer (get-buffer (buffer-name current-buffer))))
    <span class="linecomment">;; reset is-current flag in all buffers</span>
    (while buffers
      (let ((buffer (car buffers)))
        (save-excursion
          (set-buffer buffer)
          (set (make-local-variable 'grep-a-lot-is-current-buffer) nil)))
      (setq buffers (cdr buffers)))
    <span class="linecomment">;; set is-current flag in current-buffer</span>
    (save-excursion
      (set-buffer current-buffer)
      (set (make-local-variable 'grep-a-lot-is-current-buffer) t))))

(defun grep-a-lot-next-buffer (&optional reverse)
  "<span class="quote">Return next grep-a-lot buffer.
When REVERSE is non-nil, return previous buffer.
If current buffer is last then return first buffer.
Returns nil if there is no grep-a-lot buffer to select.</span>"
  (let* ((buffers (grep-a-lot-buffers reverse))
         (current (grep-a-lot-get-current-buffer buffers))
         (head (car buffers))
         (next (car (cdr (member current buffers)))))
    (and current (or next head))))

(defun grep-a-lot-prev-buffer ()
  "<span class="quote">Return previous grep-a-lot buffer.
Actually calls `grep-a-lot-next-buffer'.</span>"
  (grep-a-lot-next-buffer t))

(defun grep-a-lot-buffer-position (name)
  "<span class="quote">Return position of grep-a-lot buffer named NAME.
Return -1 if NAME is does not match `grep-a-lot-buffer-name-regexp'.</span>"
  (if (and (stringp name)
           (string-match grep-a-lot-buffer-name-regexp name))
      (string-to-number (match-string 1 name))
    -1))

(defun grep-a-lot-buffer-name (position)
  "<span class="quote">Return name of grep-a-lot buffer at POSITION.</span>"
  (concat "<span class="quote">*grep*&lt;</span>" (number-to-string position) "<span class="quote">&gt;</span>"))

(defun grep-a-lot-buffer-name-function (name)
  "<span class="quote">Set current grep search results buffer name.</span>"
  (when (string-match "<span class="quote">^i?grep$</span>" name)
    (grep-a-lot-buffer-name (1+ (grep-a-lot-buffer-position (buffer-name (grep-a-lot-last-buffer)))))))

(defun grep-a-lot-kill-buffer-hook ()
  "<span class="quote">Select previous buffer as current, in case current buffer is being killed.</span>"
  (if (and (grep-a-lot-buffer-p) grep-a-lot-is-current-buffer)
      (grep-a-lot-set-current-buffer (grep-a-lot-prev-buffer))))
      
(defun grep-a-lot-grep-setup-hook ()
  "<span class="quote">Setup buffer local storage of original buffer context.</span>"
  <span class="linecomment">;; grep-a-lot-context-initial is supposed to be set already by advised grep functions</span>
  (make-local-variable 'grep-a-lot-context-initial)
  (set (make-local-variable 'grep-a-lot-context) grep-a-lot-context-initial)
  (grep-a-lot-set-current-buffer))

(defun grep-a-lot-next-error-hook ()
  "<span class="quote">Next error hook function used to maintain the search buffer context.</span>"
  (let ((position (grep-a-lot-buffer-position (buffer-name next-error-last-buffer))))
    (when (&gt;= position 0)
      (let ((context (point-marker)))
        (save-excursion
          (set-buffer next-error-last-buffer)
          (set (make-local-variable 'grep-a-lot-context) context)
          (grep-a-lot-set-current-buffer))))))

(defun grep-a-lot-restore-context (grep-buffer &optional initial)
  "<span class="quote">Restore GREP-BUFFER context.
If INITIAL is non nil then use initial context.</span>"
  (let* ((context (and grep-buffer
                       (save-excursion
                         (set-buffer grep-buffer)
                         (if initial
                             grep-a-lot-context-initial
                           grep-a-lot-context)))))
    (when grep-buffer
      (pop-to-buffer grep-buffer)
      (grep-a-lot-set-current-buffer grep-buffer))
    (when context
      (when initial
        (goto-char (point-min))
        (setq compilation-current-error nil))
      (let* ((buffer (marker-buffer context))
             (pos (marker-position context)))
        (when buffer
          (pop-to-buffer buffer)
          (goto-char pos))))))

(defun grep-a-lot-restart-context (&optional grep-buffer)
  "<span class="quote">Restart buffer and position for the current search results buffer GREP-BUFFER.
If GREP-BUFFER is nil then restart context of current search results buffer.</span>"
  (interactive)
  (let ((grep-buffer (or (grep-a-lot-buffer-p grep-buffer)
                         (grep-a-lot-get-current-buffer))))
    (grep-a-lot-restore-context grep-buffer t)))

(defun grep-a-lot-goto-next ()
  "<span class="quote">Goto next search results buffer.</span>"
  (interactive)
  (grep-a-lot-restore-context (grep-a-lot-next-buffer)))

(defun grep-a-lot-goto-prev ()
  "<span class="quote">Goto previous search results buffer.</span>"
  (interactive)
  (grep-a-lot-restore-context (grep-a-lot-prev-buffer)))

(defun grep-a-lot-pop-stack ()
  "<span class="quote">Switch to previous search results buffer, and kill current buffer.</span>"
  (interactive)
  (let ((buffer (grep-a-lot-last-buffer)))
    (when buffer
      (grep-a-lot-set-current-buffer buffer)
      (grep-a-lot-goto-prev)
      (kill-buffer buffer))))

(defun grep-a-lot-clear-stack ()
  "<span class="quote">Kill all grep search results buffers.</span>"
  (interactive)
  (mapcar 'kill-buffer (grep-a-lot-buffers)))

(defmacro grep-a-lot-advise (func)
  "<span class="quote">Advise a grep-like function FUNC with an around-type advice,
so as to enable multiple search results buffers.</span>"
  (let ((name (make-symbol (concat "<span class="quote">grep-a-lot-</span>" (symbol-name func)))))
    `(defadvice ,func (around ,name activate)
       "<span class="quote">Use multiple search-results buffers.</span>"
       (let ((grep-a-lot-context-initial (point-marker))
             (compilation-buffer-name-function 'grep-a-lot-buffer-name-function))
         ad-do-it
         ad-return-value))))

<span class="linecomment">;; no need to advise grep-find, because it calls grep</span>
(grep-a-lot-advise grep)
(grep-a-lot-advise lgrep)
(grep-a-lot-advise rgrep)

<span class="linecomment">;; our hooks</span>
(add-hook 'next-error-hook 'grep-a-lot-next-error-hook)
(add-hook 'grep-setup-hook 'grep-a-lot-grep-setup-hook)
(add-hook 'kill-buffer-hook 'grep-a-lot-kill-buffer-hook)

(defun grep-a-lot-setup-keys()
  "<span class="quote">Define some key bindings for navigating multiple
grep search results buffers.</span>" 
  (define-key esc-map "<span class="quote">g]</span>" 'grep-a-lot-goto-next)
  (define-key esc-map "<span class="quote">g[</span>" 'grep-a-lot-goto-prev)
  (define-key esc-map "<span class="quote">g-</span>" 'grep-a-lot-pop-stack)
  (define-key esc-map "<span class="quote">g_</span>" 'grep-a-lot-clear-stack)
  (define-key esc-map "<span class="quote">g=</span>" 'grep-a-lot-restart-context))

(provide 'grep-a-lot)

<span class="linecomment">;;; grep-a-lot.el ends here</span></span></pre></div><div class="wrapper close"></div></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span><span class="translation bar"><br />  <a class="translation new" rel="nofollow" href="http://www.emacswiki.org/emacs?action=translate;id=grep-a-lot.el;missing=de_es_fr_it_ja_ko_pt_ru_se_zh">Add Translation</a></span><span class="edit bar"><br /> <a class="comment local" href="http://www.emacswiki.org/emacs/Comments_on_grep-a-lot.el">Talk</a> <a class="edit" accesskey="e" title="Click to edit this page" rel="nofollow" href="http://www.emacswiki.org/emacs?action=edit;id=grep-a-lot.el">Edit this page</a> <a class="history" rel="nofollow" href="http://www.emacswiki.org/emacs?action=history;id=grep-a-lot.el">View other revisions</a> <a class="admin" rel="nofollow" href="http://www.emacswiki.org/emacs?action=admin;id=grep-a-lot.el">Administration</a></span><!-- test --><span class="time"><br /> Last edited 2012-07-03 08:14 UTC by <a class="author" title="from 123.74.80-QoS-user.in-addr.arpa" href="http://www.emacswiki.org/emacs/AviRozen">AviRozen</a> <a class="diff" rel="nofollow" href="http://www.emacswiki.org/emacs?action=browse;diff=2;id=grep-a-lot.el">(diff)</a></span><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div>
</body>
</html>
