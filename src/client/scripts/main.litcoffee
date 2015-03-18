    'use strict'

    isTouchDevice = window.hasOwnProperty 'ontouchstart'
    pointerDownEventName = if isTouchDevice then 'touchstart' else 'mousedown'
    pointerUpEventName = if isTouchDevice then 'touchend' else 'mouseup'
    tapAnimatedElements = document.querySelectorAll '.tap-animate'

    pressHandler = (event) ->
      # Don't run animation on non-left button mouse clicks:
      return if not isTouchDevice and event.which isnt 1

      @classList?.remove 'tap-animate-release'
      @classList?.add 'tap-animate-press-and-hold'

    releaseHandler = (event) ->
      # Don't run animation on non-left button mouse clicks:
      return if not isTouchDevice and event.which isnt 1

      @classList?.remove 'tap-animate-press-and-hold'
      @classList?.add 'tap-animate-release'

    handlePointerEventsOn = (element) ->
      element.addEventListener pointerDownEventName, pressHandler
      element.addEventListener pointerUpEventName, releaseHandler

    handlePointerEventsOn element for element in tapAnimatedElements
