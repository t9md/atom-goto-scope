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
  prefix: 'goto-scope'
  config: Config
  subscriptions: null
  type2scope: null

  activate: ->
    @subscriptions = new CompositeDisposable
    types = ['string', 'function', 'variable', 'keyword', 'constant']
    commands = {}

    for type in types
      do (type) =>
        commands["#{@prefix}:#{type}-next"] = => @gotoScope('next', {type})
        commands["#{@prefix}:#{type}-prev"] = => @gotoScope('prev', {type})
    @subscriptions.add atom.commands.add 'atom-workspace', commands

  deactivate: ->
    @subscriptions?.dispose()


  gotoPoint: (editor, point) ->
    if (editor.getSelections().length is 1) and (not editor.getLastSelection().isEmpty())
      editor.selectToBufferPosition point
    else
      editor.setCursorBufferPosition point

  gotoScope: (direction, options, retry=false) ->
    return unless editor = @getEditor()
    @type2scope ?= require './type2scope'

    {type} = options
    unless options.scope
      scopeName = editor.getRootScopeDescriptor().toString()
      options.scope = (@type2scope[scopeName]?[type] or @type2scope['*'][type])

    cursor = editor.getLastCursor()
    methodName = 'find' + _.capitalize direction
    point = this[methodName](editor, options.scope)
    return unless point

    offset = null
    offset = @getOffset(type) if type
    unless offset
      @gotoPoint editor, point
      return

    orgPosition = cursor.getBufferPosition()
    @gotoPoint editor, point.translate([0, offset])
    return if options.retry

    # Locked to same position, retry without offset.
    if orgPosition.isEqual cursor.getBufferPosition()
      @gotoPoint editor, point.translate([0, -offset])
      # cursor.setBufferPosition(point.translate([0, -offset]))
      @gotoScope direction, options, true

  getScanStartPosition: (editor, direction, scopes) ->
    start = editor.getCursorBufferPosition()
    for scope in scopes
      if currentRange = editor.bufferRangeForScopeAtCursor(scope)
        start = if direction is 'next'
          currentRange.end
        else
          currentRange.start
        break
    start

  findNext: (editor, scopes) ->
    scopes     = [scopes] unless _.isArray(scopes)
    scanStart  = @getScanStartPosition(editor, 'next', scopes)
    scanEnd    = editor.getEofBufferPosition()
    @findPosition editor, 'next', [scanStart, scanEnd], scopes

  findPrev: (editor, scopes) ->
    scopes = [scopes] unless _.isArray(scopes)
    scanStart  = @getScanStartPosition(editor, 'prev', scopes)
    scanEnd    = [0, 0]
    @findPosition editor, 'prev', [scanStart, scanEnd], scopes

  findPosition: (editor, direction, scanRange, scopes) ->
    methodName = if direction is 'next'
      'scanInBufferRange'
    else
      'backwardsScanInBufferRange'

    wordRegExp = editor.getLastCursor().wordRegExp()
    point = null
    editor[methodName] wordRegExp, scanRange, ({range, stop}) =>
      for scope in scopes
        if nextRange = editor.displayBuffer.bufferRangeForScopeAtPosition(scope, range.start)
          point = nextRange.start
          stop()
          break
    point

  # getIndentLevel: (row) ->
  #   editor = @getEditor()
  #   editor.indentationForBufferRow(row)

  provideGotoScope: ->
    content = """
      *#{@prefix}*
      * Custom command feature deleted from v0.2.0.
      * If you have probrem, report issue
      * Remove custome command and keymap from `init.coffee` and `keymap.cson`.
      """
    atom.notifications.addWarning content, dismissable: true
    ->

  dump: ->
    console.log @direction

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getOffset: (type) ->
    atom.config.get "goto-scope.offset#{_.capitalize(type)}"
