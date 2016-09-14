class InvitationMailer < ApplicationMailer
  def invitation_email(requester_name:, respondent_email:, invitation_uuid:)
    @requester_name = requester_name
    @link = fill_out_url(invitationUUID: invitation_uuid)

    noreply_with_requester_name = Mail::Address.new self.class.default_params[:from]
    noreply_with_requester_name.display_name = requester_name

    mail to: respondent_email,
         from: noreply_with_requester_name.format,
         subject: 'Verzoek om vragenlijst in te vullen'
  end
end
