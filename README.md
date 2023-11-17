I wrote a README, but the code is smaller than it...

# install
not on melpa yet, but nowadays package managers can often fetch from git, otherwise just download the file.

# usage

`eval-markers-new` while on the first character of a form will prompt for a char, put a marker there, and record the association from this char to the marker.

`eval-markers-eval` will prompt for a char, and eval the form starting with the associated marker.
With universal argument, will toggle pretty printing if available.
There is a `eval-markers-toggle-pp` command to do that independently of eval'ing (as the others, it prompts for a char) but there's rarely a reason to use it

# config

## `eval-markers-want-classical-last-sexp-behaviour`

Most paredit function assume you are beyond a form when you launch the command, and if you are on the first character of a form the command will apply to the previous form.

I really dislike this, but if that is your preference set this var to `t`, and then call `eval-markers-new` where you would normally call `eval-last-sexp`.

## add/change another repl/lang
`(put 'symbol-of-a-major-mode 'eval-markers-eval-fn some-fn)`

Currently there are 2 defaults implemented, for Clojure (through cider) and for Elisp.

# faq
why not use this https://www.gnu.org/software/emacs/manual/html_node/emacs/Position-Registers.html ? It's a possibility, but I don't know, maybe people use these for something else and don't want it to interfere...
