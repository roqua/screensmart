class ResponseMailer < ApplicationMailer
  def response_email(invitation_sent_at:, requester_email:, show_secret:)
    @invitation_sent_at = invitation_sent_at
    @link = show_response_url(showSecret: show_secret)
    @show_secret = show_secret

    attachments.inline['report.pdf'] = render_report

    mail to: requester_email,
         subject: 'Resultaten invulling'
  end

  private

  def response_by_show_secret
    Response.find_by_show_secret @show_secret
  end

  def render_report
    ResponseReport.new(response_by_show_secret).render
  end
end
