
$(document).ready ->


  new QRCode document.getElementById("qrcode"), window.location.href
  $.wait ->
    $('#qrcode').css 'display', 'block'


  $.wait (->
    $('.colorbox').fancybox()
    return
  ), 1
  return

$.wait = (callback, seconds = 0.5) ->
  window.setTimeout callback, seconds * 1000

