class Interleave.Measurement
  constructor: () ->
  render: (link) ->
    $(link).on 'click', (e) ->
      $modal = $('#measurement_modal')
      $measurement = $('#measurement_modal .measurement')
      $.ajax(this.href).done (response) ->
        $measurement.html(response)
        $modal.foundation 'open'
        $('.datepicker').datepicker
          onClose: (dateText, inst) ->
            $(inst.input).focusout()
            return
          changeMonth: true
          changeYear: true
        interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
        $('.measurement_form').enableClientSideValidations()
        if $('.measurement_concept_id_select').length
          $('#measurement_measurement_concept_id').select2
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

          $('#measurement_condition_concept_id').on 'select2:select', (e) ->
            $(this).blur()
            return

        $('.measurement_form').on('ajax:success', (e, data, status, xhr) ->
          $modal.foundation 'close'
          Turbolinks.visit(location.toString())
          $('.measurements_list').fadeOut()
        ).on 'ajax:error', (e, xhr, status, error) ->

        $('.measurement_form .cancel-link').on 'click', (e) ->
          $modal.foundation 'close'
          e.preventDefault()

        return
      e.preventDefault()
      return
    return

$(document).on 'page:load ready', ->
  return unless $('.measurements.index').length > 0
  ui = new Interleave.Measurement
  ui.render('.measurement_link')