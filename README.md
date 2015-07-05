# goto-scope

Quickly go to `scope` position.

# Feature

* Move cursor to `scope` position.
* Configurable offset to set cursor position with offset.
* Use appropriate scope based on grammar.

# Commands

string
* `goto-scope:string-next`
* `goto-scope:string-prev`

function
* `goto-scope:function-next`
* `goto-scope:function-prev`

variable
* `goto-scope:variable-next`
* `goto-scope:variable-prev`

keyword
* `goto-scope:keyword-next`
* `goto-scope:keyword-prev`

constant
* `goto-scope:constant-next`
* `goto-scope:constant-prev`

# Keymap

* Normal user.

???

* [vim-mode](https://atom.io/packages/vim-mode) user.

???

* Mine.

```coffeescript
'atom-text-editor.vim-mode.command-mode':
  's': 'goto-scope:string-next',
  'S': 'goto-scope:string-prev',
  ')': 'goto-scope:function-next',
  '(': 'goto-scope:function-prev',
  ']': 'goto-scope:keyword-next',
  '[': 'goto-scope:keyword-prev',
  '@': 'goto-scope:variable-next',
  '!': 'goto-scope:constant-next',
```

# Improve language coverage

[type2scope] define, mapping from `type` to actual `scope` used in search.  
Adding new scope is very trivial.
So [report issue](https://github.com/t9md/atom-goto-scope/issues/1) for your language.

# TODO
* [x] ~~Configurable scope selector~~
* [x] Per scope offset setting
* [ ] Improve [type2scope] file
* [ ] Repeat command

[type2scope]:[https://github.com/t9md/atom-goto-scope/blob/master/lib/type2scope.coffee]
