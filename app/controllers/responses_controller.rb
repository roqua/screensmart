class ResponsesController < ApplicationController
  rescue_from BaseModel::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  wrap_parameters Response, format: :json

  def create
    @response = Response.new(convert_response_params)
    render json: ResponseSerializer.new(@response).as_json
  end

  private

  # TODO: update model to be equal to the model used by clientside so this conversion is unneccesary
  def convert_response_params
    {
      answer_values: response_params[:questions].each_with_object({}) do |question, memo|
        memo[question[:key]] = question[:answer_value]
      end,
      domain_keys: response_params[:domain_keys]
    }
  end

  def parameter_missing(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end

  def unprocessable_entity
    render json: { errors: @response.errors.full_messages }, status: :unprocessable_entity
  end

  def response_params
    whitelist = %i( answer_values domain_keys )

    if params[:response] && params[:response].keys.exclude?('domain_keys')
      raise ActionController::ParameterMissing, 'domain_keys'
    end

    params.require(:response).tap do |whitelisted|
      whitelist.each do |attribute|
        whitelisted[attribute] = params[:response][attribute]
      end
    end
  end
end
