# goto-scope

Quickly go to `scope` position.

# Feature

* Move cursor to `scope` position quickly
* User can add custom command.
* Configurable offset to set cursor position with offset.

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
  ')': 'user-goto-scope:function-next', # custom-command see Extend section
  '(': 'user-goto-scope:function-prev', # custom-command see Extend section
  '@': 'goto-scope:variable-next',
```

# Extend

1. Determine exact scope name using `editor:log-cursor-scope` from command palette.
2. Then add your custom command in `init.coffee`.


```coffeescript
# In your init.coffee
atom.packages.onDidActivatePackage (pack) ->
  if pack.name is 'goto-scope'
    gotoScope = pack.mainModule.provideGotoScope()

    atom.commands.add 'atom-text-editor',
      # define custom command to goto `new` keyword.
      'user-goto-scope:new-next': -> gotoScope('next', '.keyword.operator.new')
      'user-goto-scope:new-prev': -> gotoScope('prev', '.keyword.operator.new')

      # You can pass multiple scope, treated as 'OR' condition.
      # define custom command to goto function or function argument.
      'user-goto-scope:function-next': -> gotoScope('next', '.entity.name.function', 'variable.parameter')
      'user-goto-scope:function-prev': -> gotoScope('prev', '.entity.name.function', 'variable.parameter')
```

# TODO
* [x] Configurable scope selector.
* [x] Per scope type offset setting.
* [ ] Repeat command.
