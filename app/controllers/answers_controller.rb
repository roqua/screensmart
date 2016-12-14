class AnswersController < ApplicationController
  def create
    SetAnswer.run! answer_params

    redirect_to response_path(params[:response_uuid])
  end

  def answer_params
    params.permit(:response_uuid, :domain_id, :question_id, :answer_value)
  end
end
