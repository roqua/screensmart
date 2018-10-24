class Api::ResponsesController < ApiController
  def show
    # TODO: find by show_secret?
    # response = Response.find_by_show_secret(params[:id])
    response = Response.find_by_invitation_uuid(params[:id])
    render json: ApiResponseSerializer.new(response).as_json
  end

  def create
    outcome = StartResponse.run(invitation_params)
    if outcome.valid?
      render json: {invitation_uuid: outcome.result.invitation_uuid}
    else
      head :bad_request
    end
  end

  def invitation_params
    params.permit(:requester_name, :requester_email, domain_ids: [])
  end
end