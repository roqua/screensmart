class ResponseMailer < ApplicationMailer
  def response_email(invitation_sent_at:, requester_email:, show_secret:)
    @invitation_sent_at = invitation_sent_at
    @link = show_response_url(showSecret: show_secret)

    mail to: requester_email,
         subject: 'Resultaten invulling'
  end
end
