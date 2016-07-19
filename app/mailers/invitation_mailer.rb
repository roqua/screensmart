class InvitationMailer < ActionMailer::Base
  domain = ENV.fetch('MAILGUN_DOMAIN', 'roqua.nl')
  default from: "noreply@#{domain}"

  def invitation_email(from:, to:, response_uuid:)
    @from = from
    @link = fill_out_path(response_uuid: response_uuid)

    mail to: to,
         subject: 'Verzoek om vragenlijst in te vullen'
  end
end
