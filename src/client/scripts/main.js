(function () {
  'use strict';

  // if touch supported, listen to 'touchend', otherwise 'click'
  var isTouchDevice = 'ontouchstart' in window,
    pointerDown = isTouchDevice ? 'touchstart' : 'mousedown',
    pointerUp = isTouchDevice ? 'touchend' : 'mouseup';

  // Element.classList.add
  function addClass(element, className) {
    // Prohibit duplicate class name declarations:
    if (element.className.indexOf(className) !== -1) { return; }
    element.className += ' ' + className;
  }

  // Element.classList.remove
  function removeClass(element, className) {
    element.className.replace(new RegExp('\s+' + className), '');
  }

  function pressHandler(event) {
    // Don't run animation on non-left button mouse clicks:
    if (!isTouchDevice && event.which !== 1) { return; }

    removeClass(this, 'tap-animate-release');
    addClass(this, 'tap-animate-press-and-hold');
  }

  function releaseHandler(event) {
    // Don't run animation on non-left button mouse clicks:
    if (!isTouchDevice && event.which !== 1) { return; }

    removeClass(this, 'tap-animate-press-and-hold');
    addClass(this, 'tap-animate-release');
  }

  Array.prototype.slice
    .call(document.querySelectorAll('.tap-animate'))
    .forEach(function (element) {
      element.addEventListener(pointerDown, pressHandler);
      element.addEventListener(pointerUp, releaseHandler);
    });

}());
