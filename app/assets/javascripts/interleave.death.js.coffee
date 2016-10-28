class Interleave.Death
  constructor: () ->
  render: (link) ->
    $('.datepicker').datepicker
      onClose: (dateText, inst) ->
        $(inst.input).focusout()
        return
      changeMonth: true
      changeYear: true
      dateFormat: 'mm/dd/yy'
    interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
    $('.death_form').enableClientSideValidations()
    $('#death_cause_concept_id').select2
      ajax:
        url: interleaveDatapointConceptsUrl
        dataType: 'json'
        delay: 250
        data: (params) ->
          {
            q: params.term
            page: params.page
          }
        processResults: (data, params) ->
          params.page = params.page or 1
          results = $.map(data.concepts, (obj) ->
            obj.id = obj.concept_id
            obj.text = obj.text
            obj
          )

          {
            results: results
            pagination: more: params.page * 10 < data.total
          }
        cache: true
      escapeMarkup: (markup) ->
        markup
      minimumInputLength: 2
    return

$(document).on 'page:load ready', ->
  return unless $('.deaths.index').length > 0
  ui = new Interleave.Death
  ui.render()