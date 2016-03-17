class ResponsesController < ApplicationController
  def create
    @response = Response.new(answers: params[:answers])
    render json: ResponseSerializer.new(@response).as_json
  end
end
