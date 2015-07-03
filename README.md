# goto-scope

Quickly go to `scope` position.

# Feature

* Move cursor to `scope` position.
* Configurable offset to set cursor position with offset.

# Commands

* `goto-scope:string-next`
* `goto-scope:string-prev`
* `goto-scope:function-next`
* `goto-scope:function-prev`
* `goto-scope:variable-next`
* `goto-scope:variable-prev`
* `goto-scope:variable-next`
* `goto-scope:keyword-next`
* `goto-scope:keyword-prev`
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
  's':         'goto-scope:string-next',
  'S':         'goto-scope:string-prev',
  ')':         'goto-scope:function-next',
  '(':         'goto-scope:function-prev',
  ']':         'goto-scope:keyword-next',
  '[':         'goto-scope:keyword-prev',
  '@':         'goto-scope:variable-next',
  '!':         'goto-scope:constant-next',
```

# TODO
* [x] Configurable scope selector.
* [x] Per scope type offset setting.
* [ ] Repeat command.
