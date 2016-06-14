window.Interleave ||= {}

Interleave.init = ->
  $(document).foundation()
  Foundation.Reveal.defaults.closeOnClick = false
  Foundation.Reveal.defaults.closeOnEsc = false
  window.ClientSideValidations.callbacks.element.fail = (element, message, callback) ->
    callback()
    if element.data('valid') != false
      if element.hasClass('select2-hidden-accessible')
        field_with_errors = element.parent('.field_with_errors')
        if field_with_errors.has('.select2').length == 0
          select2Hidden = field_with_errors.children('.select2-hidden-accessible')
          select2Hidden.after field_with_errors.next('.select2')
    return

  window.ClientSideValidations.callbacks.element.pass = (element, callback) ->
    if element.hasClass('select2-hidden-accessible')
      field_with_errors = element.parent('.field_with_errors')
      if field_with_errors.has('.select2').length == 1
        select2 = field_with_errors.children('.select2')
        field_with_errors.after select2
    callback()
    return


$(document).on 'page:load ready', ->
  Interleave.init()