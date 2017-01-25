class ResponsesController < ApplicationController
  rescue_from AcceptInvitation::AlreadyFinished, with: :already_finished

  def create
    invitation_accepted = AcceptInvitation.run! params.to_unsafe_h.slice(:invitation_uuid)
    redirect_to response_url id: invitation_accepted.response_uuid
  end

  def show
    render json: ResponseSerializer.new(response_by_show_secret_or_id).as_json
  end

  def update
    response_finished = FinishResponse.run response_uuid: params[:id]
    if response_finished.valid?
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def response_by_show_secret_or_id
    return Response.find_by_show_secret params[:show_secret] if params[:show_secret]
    return Response.find params[:id] if params[:id]

    raise 'Neither `id` nor `show_secret` provided in params'
  end

  def already_finished
    head :locked
  end
end
