class ResponsesController < ApplicationController
  wrap_parameters Response, format: :json

  def create
    @response = Response.new(response_params)
    render json: ResponseSerializer.new(@response).as_json
  end

  private

  def response_params
    return unless params[:response]

    params.require(:response).tap do |whitelisted|
      whitelisted[:answer_values] = params[:response][:answer_values]
    end
  end
end
