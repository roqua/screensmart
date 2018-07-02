class FinishResponse < ActiveInteraction::Base
  string :response_uuid
  hash :demographic_info, default: nil, strip: false do
    string :age
    string :education_level
    string :employment_status
    string :gender
    string :relationship_status
  end

  validates :response_uuid, presence: true
  validate :validate_response_uuid_is_found
  validate :validate_response_is_not_finished
  validate :validate_all_questions_answered

  delegate :invitation, to: :response
  delegate :answer_values, :results, to: :response

  def execute
    response_finished =
      Events::ResponseFinished.create! invitation_uuid: invitation.uuid,
                                       response_uuid: response_uuid,
                                       answer_values: response.answer_values,
                                       results: response.results,
                                       demographic_info: demographic_info

    send_response_email

    response_finished
  end

  def send_response_email
    return unless invitation.demo?
    ResponseMailer.response_email(invitation_sent_at: invitation.requested_at,
                                  requester_email: invitation.requester_email,
                                  response: response).deliver_now
  end

  def validate_response_uuid_is_found
    return if Response.exists? response_uuid
    errors.add(:response_uuid, 'is unknown')
  end

  def validate_response_is_not_finished
    return unless Events::ResponseFinished.find_by(response_uuid: response_uuid)
    errors.add(:response_uuid, 'has already been finished')
  end

  def validate_all_questions_answered
    return if !response_exists? || response.done
    errors.add(:response_uuid, 'not all questions have been answered')
  end

  def response
    Response.find response_uuid
  end

  def response_exists?
    Response.exists? response_uuid
  end
end
