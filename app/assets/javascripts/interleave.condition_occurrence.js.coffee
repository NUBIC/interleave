class Interleave.ConditionOccurrence
  constructor: () ->
  render: (link) ->
    $(link).on 'click', (e) ->
      $modal = $('#condition_occurrence_modal')
      $condition_occurrence = $('#condition_occurrence_modal .condition_occurrence')
      $.ajax(this.href).done (response) ->
        $condition_occurrence.html(response)
        $modal.foundation 'open'
        $('.datepicker').datepicker
          onClose: (dateText, inst) ->
            $(inst.input).focusout()
            return
          changeMonth: true
          changeYear: true
        interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
        $('.condition_occurrence_form').enableClientSideValidations()
        $('#condition_occurrence_condition_concept_id').select2
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

        $('#condition_occurrence_condition_concept_id').on 'select2:select', (e) ->
          $(this).blur()
          return

        $('.condition_occurrence_form').on('ajax:success', (e, data, status, xhr) ->
          $modal.foundation 'close'
          Turbolinks.visit(location.toString())
          $('.condition_occurrences_list').fadeOut()
        ).on 'ajax:error', (e, xhr, status, error) ->

        $('.condition_occurrence_form .cancel-link').on 'click', (e) ->
          $modal.foundation 'close'
          e.preventDefault()

        return
      e.preventDefault()
      return
    return

$(document).on 'page:load ready', ->
  return unless $('.condition_occurrences.index').length > 0
  ui = new Interleave.ConditionOccurrence
  ui.render('.condition_occurrence_link')