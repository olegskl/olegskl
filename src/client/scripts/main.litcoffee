    'use strict'

    isTouchDevice = window.hasOwnProperty 'ontouchstart'
    pointerDownEventName = if isTouchDevice then 'touchstart' else 'mousedown'
    pointerUpEventName = if isTouchDevice then 'touchend' else 'mouseup'

    pressHandler = (event) ->
      # Don't run animation on non-left button mouse clicks:
      return if (not isTouchDevice and event.which isnt 1)

      @.classList?.remove 'tap-animate-release'
      @.classList?.add 'tap-animate-press-and-hold'

    releaseHandler = (event) ->
      # Don't run animation on non-left button mouse clicks:
      return if (not isTouchDevice and event.which isnt 1)

      @.classList.remove 'tap-animate-press-and-hold'
      @.classList.add 'tap-animate-release'

    Array::slice
      .call document.querySelectorAll '.tap-animate'
      .forEach (element) ->
        element.addEventListener pointerDownEventName, pressHandler
        element.addEventListener pointerUpEventName, releaseHandler
