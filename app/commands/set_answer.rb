class SetAnswer < ActiveInteraction::Base
  string :response_uuid
  string :domain_id
  string :question_id
  integer :answer_value

  validates :response_uuid, :domain_id, :question_id, :answer_value, presence: true
  validate :validate_response_uuid_is_found
  validate :validate_response_is_not_finished
  validate :validate_domain_id_exists
  validate :validate_question_id_exists
  validate :validate_answer_value_included_in_answer_options

  def execute
    Events::AnswerSet.create! response_uuid: response_uuid,
                              domain_id: domain_id,
                              question_id: question_id,
                              answer_value: answer_value
  end

  def validate_response_uuid_is_found
    return if Response.exists? response_uuid
    errors.add(:response_uuid, 'is unknown')
  end

  def validate_response_is_not_finished
    return unless Events::ResponseFinished.find_by(response_uuid: response_uuid)
    errors.add(:response_uuid, 'has already been finished')

  def validate_domain_id_exists
    return if RPackage.domain_ids.include?(domain_id)
    errors.add(:domain_id, 'is unknown')
  end

  def validate_question_id_exists
    return if RPackage.question_by_id(question_id)
    errors.add(:question_id, 'is unknown')
  end

  def validate_answer_value_included_in_answer_options
    # Answer values validity depends on a valid question
    return if errors[:question_id].present?

    return if question.answer_option_ids.include?(answer_value)
    errors.add(:answer_value, 'is not valid for this question')
  end

  def question
    Question.find(question_id)
  end
end
