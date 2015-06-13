# goto-scope

Quickly go to `scope` position.

# Feature

* Move cursor to `scope` position quickly
* User can add custom command.

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
  's': 'goto-scope:string-next',
  'S': 'goto-scope:string-prev',
  ')': 'goto-scope:function-next',
  '(': 'goto-scope:function-prev',
  '@': 'goto-scope:variable-next',
```

# Extend

1. Determine exact scope name using `editor:log-cursor-scope` from command palette.
2. Then add your custom command in `init.coffee`.

In following example, define custom goto command that let you goto `new` keyword.

```coffeescript
# In your init.coffee
atom.packages.onDidActivatePackage (pack) ->
  if pack.name is 'goto-scope'
    gotoScope = pack.mainModule.provideGotoScope()

    atom.commands.add 'atom-text-editor',
      'user-goto-scope:new-next': -> gotoScope('next', '.keyword.operator.new')
```

# TODO
* [x] Configurable scope selector.
* [ ] Repeat command.
