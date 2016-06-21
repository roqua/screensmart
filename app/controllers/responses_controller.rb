class ResponsesController < ApplicationController
  rescue_from BaseModel::RecordInvalid, ActionController::ParameterMissing, with: :unprocessable_entity

  wrap_parameters Response, format: :json

  def create
    @response = Response.new(convert_response_params)
    render json: ResponseSerializer.new(@response).as_json
  end

  private

  # TODO: update model to be equal to the model used by clientside so this conversion is unneccesary
  def convert_response_params
    {
      answer_values: Hash[response_params[:questions].map { |q| [q['id'], q['answer_value']] }],
      domain_ids: response_params[:domain_ids]
    }
  end

  def unprocessable_entity(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def response_params
    whitelist = %i( questions domain_ids )

    if params[:response] && params[:response].keys.exclude?('domain_ids')
      raise ActionController::ParameterMissing, 'domain_ids'
    end

    params.require(:response).tap do |whitelisted|
      whitelist.each do |attribute|
        whitelisted[attribute] = params[:response][attribute] || []
      end
    end
  end
end
