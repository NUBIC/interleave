(exports ? this).Interleave = {}

(exports ? this).Interleave.ConditionOccurencesUI = (config) ->

  $('#new_condition_occurrence_link').on 'click', (e) ->
    $modal = $('#new_condition_occurrence')
    $condition_occurrence = $('#new_condition_occurrence .condition_occurrence')
    $.ajax(this.href).done (response) ->
      $condition_occurrence.html(response)
      $modal.foundation 'open'
      $('.datepicker').datepicker()
      interleaveDatapointConceptsUrl = $('#concepts_interleave_datapoint_url').attr('href')
      templateResult = (concept) ->
        concept.text
      templateSelection = (concept) ->
        concept.id
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
            # parse the results into the format expected by Select2
            # since we are using custom formatting functions we do not need to
            # alter the remote JSON data, except to indicate that infinite
            # scrolling can be used
            params.page = params.page or 1

            results = $.map(data, (obj) ->
              obj.id = obj.concept_id
              obj.text = obj.name
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
        templateResult: templateResult
        templateSelection: templateSelection
      return
    e.preventDefault()
    return
  return