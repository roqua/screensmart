class InvitationsController < ApplicationController
  def create
    outcome = SendInvitation.run(params)
    if outcome.valid?
      head :created
    else
      head :bad_request
    end
  end
end
