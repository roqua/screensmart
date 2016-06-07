class ResponsesController < ApplicationController
  rescue_from BaseModel::RecordInvalid, with: :unprocessable_entity

  wrap_parameters Response, format: :json

  def create
    @response = Response.new(convert_response_params)
    render json: ResponseSerializer.new(@response).as_json
  rescue ActionController::ParameterMissing
    head :unprocessable_entity
  end

  private

  # TODO: update model to be equal to the model used by clientside so this conversion is unneccesary
  def convert_response_params
    {
      answer_values: response_params['questions'].each_with_object({}) do |question, memo|
        memo[question['key']] = question['answer_value']
      end
    }
  end

  def unprocessable_entity
    render json: { errors: @response.errors.full_messages }, status: :unprocessable_entity
  end

  def response_params
    whitelist = %i( answer_values domain_keys )
    required_question_attributes = %i( key value)

    raise ActionController::ParameterMissing, 'domain_keys' unless params[:response] && params[:response].keys.include?('domain_keys')

    params.require(:response).tap do |whitelisted|
      whitelist.each do |attribute|
        whitelisted[attribute] = params[:response][attribute]
      end
      whitelisted[:questions].each do |question|
        required_question_attributes.each do |attribute|
          raise ActionController::ParameterMissing, questions: [attribute] unless question[attribute].present?
        end
      end
    end
  end
end
