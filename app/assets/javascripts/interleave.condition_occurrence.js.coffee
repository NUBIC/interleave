class Interleave.ConditionOccurrence
  constructor: () ->
  render: ->
    $('#new_condition_occurrence_link').on 'click', (e) ->
      $modal = $('#new_condition_occurrence_modal')
      $condition_occurrence = $('#new_condition_occurrence_modal .condition_occurrence')
      $.ajax(this.href).done (response) ->
        $condition_occurrence.html(response)
        $modal.foundation 'open'
        $('.datepicker').datepicker
          onClose: (dateText, inst) ->
            $(inst.input).change().focusout()
            return
          changeMonth: true
          changeYear: true
        interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
        $('#new_condition_occurrence').enableClientSideValidations()
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

        $('#condition_occurrence_condition_type_concept_id').on 'change', (e) ->
          $(this).blur()
          return

        $('#new_condition_occurrence').on('ajax:success', (e, data, status, xhr) ->
          $modal.foundation 'close'
          Turbolinks.visit(location.toString())
          $('.condition_occurrences_list').fadeOut()
        ).on 'ajax:error', (e, xhr, status, error) ->

        $('#new_condition_occurrence .cancel-link').on 'click', (e) ->
          $modal.foundation 'close'

        return
      e.preventDefault()
      return
    return

$(document).on 'page:load ready', ->
  return unless $('.condition_occurrences.index').length > 0
  ui = new Interleave.ConditionOccurrence
  ui.render()