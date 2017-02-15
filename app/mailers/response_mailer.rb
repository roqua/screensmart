class ResponseMailer < ApplicationMailer
  def response_email(invitation_sent_at:, requester_email:, response:)
    @invitation_sent_at = invitation_sent_at
    @response = response
    @link = show_response_url(showSecret: response.show_secret)

    attachments['Rapport-CATja-Screening.pdf'] = render_report

    mail to: requester_email,
         subject: 'Resultaten invulling'
  end

  private

  def render_report
    ResponseReport.new(@response).render
  end
end
