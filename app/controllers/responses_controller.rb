class ResponsesController < ApplicationController
  def show
    response = Response.find(params[:id])
    render json: ResponseSerializer.new(response).as_json
  end
end
