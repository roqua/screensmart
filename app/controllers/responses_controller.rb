class ResponsesController < ApplicationController
  def show
    response = Response.find(params[:uuid])
    render json: ResponseSerializer.new(response).as_json
  end
end
