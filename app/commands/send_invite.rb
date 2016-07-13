class SendInvite < ActiveInteraction::Base
  string :requester_email
  array :domains do
    string
  end

  def execute
    Events::InviteSent.create!(
      response_uuid: SecureRandom.uuid,
      requester_email: requester_email,
      domains: domains
    )
  end
end
