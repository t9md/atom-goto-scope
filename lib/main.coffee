{CompositeDisposable} = require 'atom'

module.exports =
  activate: (state) ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-workspace',
      'select-scope:next-string': => @nextScope('.string.quoted')
      'select-scope:prev-string': => @prevScope('.string.quoted')
      # 'select-scope:next-string': => @nextScope('.entity.name.function')
      # 'select-scope:next-string': => @nextScope('.variable.other.readwrite.instance')

  bufferRangeForScopeAtCursor: (scopeSelector) ->
    @displayBuffer.bufferRangeForScopeAtPosition(scopeSelector, @getCursorBufferPosition())

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


  getEditor: ->
    atom.workspace.getActiveTextEditor()

  nextScope: (scope) ->
    @goToScope('next', scope)

  prevScope: (scope) ->
    @goToScope('prev', scope)

  goToScope: (direction, scope) ->
    editor = @getEditor()
    cursor = editor.getLastCursor()

    find =
      if direction is 'next'
        @getNextPositionForScope.bind(cursor)
      else if direction is 'prev'
        @getPreviousPositionForScope.bind(cursor)

    if point = find(scope)
      cursor.setBufferPosition(point)
