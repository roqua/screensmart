class InvitationsController < ApplicationController
  def create
    # TODO: Commands::SendInvitation.run!
    #       (actually send the invitation and save the event)
    head :created
  end
end
