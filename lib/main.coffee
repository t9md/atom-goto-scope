{CompositeDisposable} = require 'atom'

module.exports =
  direction: null
  activate: (state) ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-workspace',
      'goto-scope:next': => @next()
      'goto-scope:prev': => @prev()

      'goto-scope:dump': => @dump()

      'goto-scope:repeat-next': => @repeat('next')
      'goto-scope:repeat-prev': => @repeat('prev')

      'goto-scope:goto-string':   => @goToScope('.string.quoted')
      'goto-scope:goto-function': => @goToScope('.entity.name.function')
      'goto-scope:goto-variable': => @goToScope('.variable.other.readwrite.instance')

  getNextPositionForScope: (scope, options = {}) ->
    start = @getBufferPosition()
    if currentRange = @editor.bufferRangeForScopeAtCursor(scope)
      start = currentRange.end

    scanRange = [start, @editor.getEofBufferPosition()]

    nextPosition = null
    @editor.scanInBufferRange (options.wordRegex ? @wordRegExp()), scanRange, ({range, stop}) =>
      if nextRange = @editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
        nextPosition = nextRange.start
        stop()
    nextPosition

  getPreviousPositionForScope: (scope, options = {}) ->
    start = @getBufferPosition()
    if currentRange = @editor.bufferRangeForScopeAtCursor(scope)
      start = currentRange.start

    scanRange = [start, [0,0]]

    nextPosition = null
    @editor.backwardsScanInBufferRange (options.wordRegex ? @wordRegExp()), scanRange, ({range, stop}) =>
      if nextRange = @editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
        nextPosition = nextRange.start
        stop()
    nextPosition

  setup: (@direction) ->
    editor = @getEditor()
    @editorElement = atom.views.getView(editor)
    @editorElement.classList.add('goto-scope')

  repeat: (@direction) ->
    return unless @lastScope
    @setup @direction
    @goToScope @lastScope

  dump: ->
    console.log @direction

  next: ->
    @setup('next')

  prev: ->
    @setup('prev')

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  reset: ->
    @editorElement.classList.remove('goto-scope')

  goToScope: (scope) ->
    @lastScope = scope
    @lastDirection = @direction
    editor = @getEditor()
    cursor = editor.getLastCursor()

    find =
      if @direction is 'next'
        @getNextPositionForScope.bind(cursor)
      else if @direction is 'prev'
        @getPreviousPositionForScope.bind(cursor)

    if point = find(scope)
      cursor.setBufferPosition(point)
    @reset()
