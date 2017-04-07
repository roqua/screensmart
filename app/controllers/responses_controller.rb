class ResponsesController < ApplicationController
  rescue_from AcceptInvitation::AlreadyFinished, with: :already_finished

  def create
    invitation_accepted = AcceptInvitation.run! invitation_params
    redirect_to response_url id: invitation_accepted.response_uuid
  end

  def show
    render json: ResponseSerializer.new(response_by_show_secret_or_id).as_json
  end

  def update
    response_finished = FinishResponse.run response_uuid: params[:id],
                                           demographic_info: params[:demographic_info].to_unsafe_h
    if response_finished.valid?
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.permit(:invitation_uuid)
  end

  def response_by_show_secret_or_id
    return Response.find_by_show_secret params[:show_secret] if params[:show_secret]
    return Response.find params[:id] if params[:id]

    raise 'Neither `id` nor `show_secret` provided in params'
  end

  def already_finished
    head :locked
  end
end
