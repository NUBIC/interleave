class Interleave.ProcedureOccurrence
  constructor: () ->
  render: (link) ->
    $(link).on 'click', (e) ->
      $modal = $('#procedure_occurrence_modal')
      $procedure_occurrence = $('#procedure_occurrence_modal .procedure_occurrence')
      $.ajax(this.href).done (response) ->
        $procedure_occurrence.html(response)
        $modal.foundation 'open'
        $('.datepicker').datepicker
          onClose: (dateText, inst) ->
            $(inst.input).focusout()
            return
          changeMonth: true
          changeYear: true
        interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
        $('.procedure_occurrence_form').enableClientSideValidations()
        $('#procedure_occurrence_procedure_concept_id').select2
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

        $('#procedure_occurrence_procedure_concept_id').on 'select2:select', (e) ->
          $(this).blur()
          return

        $('#procedure_occurrence_procedure_type_concept_id').on 'change', (e) ->
          $(this).blur()
          return

        $('.procedure_occurrence_form').on('ajax:success', (e, data, status, xhr) ->
          $modal.foundation 'close'
          Turbolinks.visit(location.toString())
          $('.procedure_occurrences_list').fadeOut()
        ).on 'ajax:error', (e, xhr, status, error) ->

        $('.procedure_occurrence_form .cancel-link').on 'click', (e) ->
          $modal.foundation 'close'
          e.preventDefault()

        return
      e.preventDefault()
      return
    return

$(document).on 'page:load ready', ->
  return unless $('.procedure_occurrences.index').length > 0
  ui = new Interleave.ProcedureOccurrence
  ui.render('.procedure_occurrence_link')