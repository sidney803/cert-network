
$(document).ready ->


  new QRCode document.getElementById("qrcode"), window.location.href
  $.wait ->
    $('#qrcode').css 'display', 'block'


  $.wait (->
    $('.image').fancybox()

    $('.pdf').fancybox
      openEffect: 'elastic'
      closeEffect: 'elastic'
      autoSize: true
      type: 'iframe'
      iframe: preload: false

    return
  ), 1
  return

$.wait = (callback, seconds = 0.5) ->
  window.setTimeout callback, seconds * 1000

