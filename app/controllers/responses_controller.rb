class ResponsesController < ApplicationController
  def create
    @response = Response.new(answer_values: params[:answer_values])
    render json: ResponseSerializer.new(@response).as_json
  end
end
