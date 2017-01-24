$(document).on "ready", ->
# Leer los cookies y obtener de acuerdo al nombre
  getCookie = (cname) ->
    name = cname + '='
    ca = document.cookie.split(';')
    i = 0
    while i < ca.length
      c = ca[i]
      while c.charAt(0) == ' '
        c = c.substring(1)
      if c.indexOf(name) == 0
        return c.substring(name.length, c.length)
      i++
    ''

  body = $('body')
  $('.sidebar-toggle').on 'click', ->
    collapse = if getCookie('sidebar_position') == '' then 'sidebar-collapse' else ''
    document.cookie = 'sidebar_position= ' + collapse + '; path=/'
    return
  #Remover mensajes informativos
  setTimeout (->
    $('#notice').slideUp 'normal', ->
      $(this).remove()
      return
    return
  ), 7000
  body.on('show.bs.dropdown', '.dropdown', (e) ->
    $(this).find('.dropdown-menu').first().stop(true, true).slideDown()
    return
  ).on 'hide.bs.dropdown', '.dropdown', (e) ->
    $(this).find('.dropdown-menu').first().stop(true, true).slideUp()
    return
  return