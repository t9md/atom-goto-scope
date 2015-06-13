# goto-scope

Quickly go to `scope` position.

# Keymap

No keymap by default.

# Feature

* Move cursor to `scope` position quickly

# Commands

* `goto-scope:string-next`
* `goto-scope:string-prev`
* `goto-scope:function-next`
* `goto-scope:function-prev`
* `goto-scope:variable-next`
* `goto-scope:variable-prev`
* `goto-scope:variable-next`


# Keymap

* Normal user.

???

* [vim-mode](https://atom.io/packages/vim-mode) user.

???

* Mine.

```coffeescript
'atom-text-editor.vim-mode.command-mode':
  's':   'goto-scope:string-next',
  'S':   'goto-scope:string-prev',
  ')': 'goto-scope:function-next',
  '(': 'goto-scope:function-prev',
  '@':   'goto-scope:variable-next',
```

# TODO
* [ ] Configurable scope selector?
