class InterleaveDatapointsController < ApplicationController
  before_filter :load_interleave_datapoint, only: :concepts

  def concepts
    params[:page]||= 1
    @all_concepts = @interleave_datapoint.concepts(params[:q])
    @concepts = @all_concepts.select('concept.concept_id, concept.concept_name AS text').paginate(per_page: 10, page: params[:page])
    respond_to do |format|
        format.json {
          render json: {
            concepts: @concepts,
            total:    @all_concepts.count,
            links: { self: @concepts.current_page , next: @concepts.next_page }
        }.to_json
      }
    end
  end

  private
    def load_interleave_datapoint
      @interleave_datapoint = InterleaveDatapoint.find(params[:id])
    end
end