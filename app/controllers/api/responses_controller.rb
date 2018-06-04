class Api::ResponsesController < ApiController
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
