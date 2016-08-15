class Interleave.DrugExposure
  constructor: () ->
  render: (link) ->
    $(link).on 'click', (e) ->
      $modal = $('#drug_exposure_modal')
      $drug_exposure = $('#drug_exposure_modal .drug_exposure')
      $.ajax(this.href).done (response) ->
        $drug_exposure.html(response)
        $modal.foundation 'open'
        $('.datepicker').datepicker
          onClose: (dateText, inst) ->
            $(inst.input).focusout()
            return
          changeMonth: true
          changeYear: true
        interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
        $('.drug_exposure_form').enableClientSideValidations()
        $('#drug_exposure_drug_concept_id').select2
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

        $('#drug_exposure_condition_concept_id').on 'select2:select', (e) ->
          $(this).blur()
          return

        $('.drug_exposure_form').on('ajax:success', (e, data, status, xhr) ->
          $modal.foundation 'close'
          Turbolinks.visit(location.toString())
          $('.drug_exposures_list').fadeOut()
        ).on 'ajax:error', (e, xhr, status, error) ->

        $('.drug_exposure_form .cancel-link').on 'click', (e) ->
          $modal.foundation 'close'
          e.preventDefault()

        return
      e.preventDefault()
      return
    return

$(document).on 'page:load ready', ->
  return unless $('.drug_exposures.index').length > 0
  ui = new Interleave.DrugExposure
  ui.render('.drug_exposure_link')