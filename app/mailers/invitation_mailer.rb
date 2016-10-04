class InvitationMailer < ApplicationMailer
  def invitation_email(requester_name:, respondent_email:, invitation_uuid:)
    @requester_name = requester_name
    @link = fill_out_url(invitationUUID: invitation_uuid)

    mail to: respondent_email,
         subject: "Verzoek van #{requester_name} om vragenlijst in te vullen"
  end
end
