class InvitationsController < ApplicationController
  def create
    outcome = SendInvitation.run(invitation_params.to_h)
    if outcome.valid?
      head :created
    else
      head :bad_request
    end
  end

  def invitation_params
    params.permit(:requester_name, :requester_email, :respondent_email, domain_ids: [])
  end
end
