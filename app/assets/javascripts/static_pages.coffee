onScroll = (event)->
  # Medir distancia hasta arriva
  scrollPos = $(document).scrollTop() - 90
  $('.nav-pills a').each ->
    if event.type != "click"
      currLink = $(this)
      refElement = $(currLink.attr('href'))
      if refElement.position().top <= scrollPos and refElement.position().top + refElement.height() > scrollPos
        $('.nav-pills li').removeClass 'active'
        currLink.parent().addClass 'active'
      else
        currLink.parent().removeClass 'active'
      return
    return

$(document).on "scroll", onScroll

$ ->
  slideToTop = $('<div />')
  slideToTop.html '<i class="fa fa-chevron-up"></i>'
  slideToTop.css
    position: 'fixed'
    bottom: '20px'
    right: '25px'
    width: '40px'
    height: '40px'
    color: '#eee'
    'font-size': ''
    'line-height': '40px'
    'text-align': 'center'
    'background-color': '#222d32'
    cursor: 'pointer'
    'border-radius': '5px'
    'z-index': '99999'
    opacity: '.7'
    'display': 'none'
  slideToTop.on 'mouseenter', ->
    $(this).css 'opacity', '1'
    return
  slideToTop.on 'mouseout', ->
    $(this).css 'opacity', '.7'
    return
  $('.wrapper').append slideToTop
  $(window).scroll ->
    if $(window).scrollTop() >= 150
      if !$(slideToTop).is(':visible')
        $(slideToTop).fadeIn 500
    else
      $(slideToTop).fadeOut 500
    return
  $(slideToTop).click ->
    $('body').animate {scrollTop: 0}, 500
    return
  # Desplazar con animación
  $('.nav-pills li:not(.treeview) a').click ->
    $this = $(this)
    target = $this.attr('href')
    $this.closest("ul").find(".active").removeClass("active")
    $this.parent().addClass("active")
    if typeof target == 'string'
      $('body').animate {scrollTop: $(target).offset().top + 'px'}, 500
    return
