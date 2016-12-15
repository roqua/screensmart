class FinishResponse < ActiveInteraction::Base
  string :response_uuid

  validates :response_uuid, presence: true
  validate :validate_response_uuid_is_found
  validate :validate_invitation_uuid_is_found
  validate :validate_response_is_not_finished
  validate :validate_all_questions_answered

  def execute
    response_finished =
      Events::ResponseFinished.create! invitation_uuid: invitation.invitation_uuid,
                                       response_uuid: response_uuid,
                                       results: response.results

    send_response_email

    response_finished
  end

  def send_response_email
    ResponseMailer.response_email(invitation_sent_at: invitation_sent.created_at,
                                  requester_email: invitation_sent.requester_email,
                                  show_secret: invitation.show_secret).deliver_now
  end

  def validate_response_uuid_is_found
    return if Response.exists? response_uuid
    errors.add(:response_uuid, 'is unknown')
  end

  def validate_invitation_uuid_is_found
    return if invitation
    errors.add(:invitation_uuid, 'is not found')
  end

  def validate_response_is_not_finished
    return unless Events::ResponseFinished.find_by(response_uuid: response_uuid)
    errors.add(:response_uuid, 'has already been finished')
  end

  def validate_all_questions_answered
    return if !response_exists? || response.done
    errors.add(:response_uuid, 'not all questions have been answered')
  end

  # The invitation that has been used to start the response
  def invitation
    Events::InvitationAccepted.find_by(response_uuid: response_uuid)
  end

  def invitation_sent
    Events::InvitationSent.find_by(invitation_uuid: invitation.invitation_uuid)
  end

  def response
    Response.find response_uuid
  end

  def response_exists?
    Response.exists? response_uuid
  end
end
