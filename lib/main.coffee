{CompositeDisposable} = require 'atom'

module.exports =
  disposables: null

  activate: ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-workspace',
      'goto-scope:string-next':   => @gotoScope('next', '.string.quoted')
      'goto-scope:string-prev':   => @gotoScope('prev', '.string.quoted')
      'goto-scope:function-next': => @gotoScope('next', '.entity.name.function')
      'goto-scope:function-prev': => @gotoScope('prev', '.entity.name.function')
      'goto-scope:variable-next': => @gotoScope('next', '.variable')
      'goto-scope:variable-prev': => @gotoScope('prev', '.variable')

  deactivate: ->
    @disposables?.dispose()

  getFinderForScope: (cursor, scopes) ->
    finder = (direction) ->
      if direction is 'next'
        options =
          startRangePoint: 'end'
          scanRangeEND:    @editor.getEofBufferPosition()
          finder:          'scanInBufferRange'
      else if 'prev'
        options =
          startRangePoint: 'start'
          scanRangeEND:    [0, 0]
          finder:          'backwardsScanInBufferRange'

      start = @getBufferPosition()

      for scope in scopes
        if currentRange = @editor.bufferRangeForScopeAtCursor(scope)
          start = currentRange[options.startRangePoint]
          break

      scanRange = [start, options.scanRangeEND]

      nextPosition = null
      @editor[options.finder] @wordRegExp(), scanRange, ({range, stop}) =>
        for scope in scopes
          if nextRange = @editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
            nextPosition = nextRange.start
            stop()
            break
      nextPosition

    finder.bind(cursor)

  dump: ->
    console.log @direction

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  gotoScope: (direction, scopes...) ->
    return unless editor = @getEditor()

    cursor = editor.getLastCursor()
    find   = @getFinderForScope(cursor, scopes)

    if point = find(direction)
      cursor.setBufferPosition(point)

  provideGotoScope: ->
    @gotoScope.bind(this)
