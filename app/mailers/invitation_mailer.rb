class InvitationMailer < ActionMailer::Base
  domain = ENV.fetch('MAILGUN_DOMAIN', 'roqua.nl')
  default from: "noreply@#{domain}"

  def invitation_email(requester_email:, respondent_email:, response_uuid:)
    @requester_email = requester_email
    @link = fill_out_url(responseUUID: response_uuid)

    mail to: respondent_email,
         subject: 'Verzoek om vragenlijst in te vullen'
  end
end
