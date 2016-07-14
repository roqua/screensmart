class SetAnswer < ActiveInteraction::Base
  string :response_uuid
  string :question_id
  integer :answer_value

  validates :response_uuid, :question_id, :answer_value, presence: true
  validate :validate_response_uuid_is_found
  validate :validate_question_id_defined_by_r_package
  validate :validate_answer_value_included_in_answer_options

  def execute
    Events::AnswerSet.create!(
      response_uuid: response_uuid,
      question_id: question_id,
      answer_value: answer_value
    )
  end

  def validate_response_uuid_is_found
    return if Events::InvitationSent.find_by(response_uuid: response_uuid)
    errors.add(:response_uuid, 'is unknown')
  end

  def validate_question_id_defined_by_r_package
    return unless RPackage.question_by_id(question_id).nil?
    errors.add(:question_id, 'is unknown')
  end

  def validate_answer_value_included_in_answer_options
    question = RPackage.question_by_id(question_id)
    if question
      answer_option_ids = question['answer_options'].map { |o| o['id'] }
      return if answer_option_ids.include?(answer_value)
      errors.add(:answer_value, 'is not valid for this question')
    else
      errors.add(:answer_value, 'is unknown')
    end
  end

  def domain
    Events::InvitationSent.find_by(response_uuid: response_uuid).domains.first
  end
end
