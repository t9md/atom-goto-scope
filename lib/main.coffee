{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

Config =
  offsetString:
    order:   1
    type:    'integer'
    default: 0
    minimum: 0
  offsetFunction:
    order:   2
    type:    'integer'
    default: 0
    minimum: 0
  offsetVariable:
    order:   3
    type:    'integer'
    default: 0
    minimum: 0
  offsetKeyword:
    order:   4
    type:    'integer'
    default: 0
    minimum: 0
  offsetConstant:
    order:   5
    type:    'integer'
    default: 0
    minimum: 0

module.exports =
  config: Config
  subscriptions: null
  prefix: 'goto-scope'
  type2scope: null

  activate: ->
    @subscriptions = new CompositeDisposable
    types = [ "string", "function", "variable", "keyword", "constant"]
    commands = {}

    for type in types
      do (type) =>
        commands["#{@prefix}:#{type}-next"] = => @gotoScope('next', {type})
        commands["#{@prefix}:#{type}-prev"] = => @gotoScope('prev', {type})
    commands["#{@prefix}:dump"] = => @dump()
    @subscriptions.add atom.commands.add 'atom-workspace', commands

  deactivate: ->
    @subscriptions?.dispose()

  getScanStartPosition: (direction, scopes) ->
    start = editor.getCursorBufferPosition()
    for scope in scopes
      if currentRange = editor.bufferRangeForScopeAtCursor(scope)
        start = if direction is 'next'
          currentRange.end
        else
          currentRange.start
        break
    start

  scanInBufferRange: (editor, scanRange, direction)->
    methodName = if direction is 'next'
    else

    wordRegExp = editor.getLastCursor().wordRegExp()
    editor.backwardsScanInBufferRange wordRegExp, [scanStart, scanEnd], ({range, stop}) =>
      for scope in scopes
        if nextRange = editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
          nextPosition = nextRange.start
          stop()
          break
    nextPosition


  findNext: (editor, scopes) ->
    scopes     = [scopes] unless _.isArray(scopes)
    scanStart  = @getScanStartPosition('next', scopes)
    scanEnd    = editor.getEofBufferPosition()]
    wordRegExp = editor.getLastCursor().wordRegExp()

    nextPosition = null
    editor.scanInBufferRange wordRegExp, [scanStart, scanEnd], ({range, stop}) =>
      for scope in scopes
        if nextRange = editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
          nextPosition = nextRange.start
          stop()
          break
    nextPosition

  findPrev: (editor, scopes) ->
    scopes = [scopes] unless _.isArray(scopes)
    scanStart  = @getScanStartPosition('prev', scopes)
    scanEnd    = [0, 0]
    wordRegExp = editor.getLastCursor().wordRegExp()

    nextPosition = null
    editor.backwardsScanInBufferRange wordRegExp, [scanStart, scanEnd], ({range, stop}) =>
      for scope in scopes
        if nextRange = editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
          nextPosition = nextRange.start
          stop()
          break
    nextPosition

  dump: ->
    console.log @direction

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getOffset: (type) ->
    atom.config.get "goto-scope.offset#{_.capitalize(type)}"

  dump: ->
    # console.log

  gotoScope: (direction, options) ->
    return unless editor = @getEditor()
    @type2scope ?= require './type2scope'

    {type} = options
    offset = @getOffset type
    unless options.scope
      scopeName = editor.getRootScopeDescriptor().toString()
      options.scope = (@type2scope[scopeName]?[type] or @type2scope['*'][type])

    cursor = editor.getLastCursor()
    orgPosition = cursor.getBufferPosition()

    methodName = 'find' + _.capitalize direction
    return unless point = this[methodName](editor, options.scope)

    if offset
      cursor.setBufferPosition(point.translate([0, offset]))
      return if options.retry
      # Locked to same position because of offset
      # Retry after adjusting offset.
      if orgPosition.isEqual cursor.getBufferPosition()
        cursor.setBufferPosition(point.translate([0, -offset]))
        @gotoScope direction, scope, _.extend(options, retry: true)
    else
      cursor.setBufferPosition(point)

  provideGotoScope: ->
    @gotoScope.bind(this)
