# A stateless response to a given set of questions.
# Initializing is done by setting answer_values as a hash, for example:
#   r = Response.new(answer_values: { 'EL02' => 1 })
#
# After this, all attributes can be read in an OOP way, for example:
#   r.questions # All questions, including the next (unanswered) one
#   # => [#<Question:0x007faadb3459a8 @id="EL02", @answer_value: 1>,
#         #<Question:0x007faadb2d49d8 @id="EL03">]
class Response < BaseModel
  attr_accessor :uuid

  # Accessors for attributes defined by events
  delegate :show_secret, to: :invitation_accepted
  delegate :created_at, to: :invitation_accepted
  delegate :domain_ids, to: :invitation
  delegate :requested_at, to: :invitation

  # accessors for attributes defined by R package
  %i(next_question_id done).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        RPackage.data_for(answer_values, domain_ids)[r_attribute]
      end
    end
  end

  def domain_responses
    domain_ids.map do |domain_id|
      DomainResponse.new(response: self, domain_id: domain_id)
    end
  end

  # As stored in FinishResponse event
  def results
    domain_responses.map do |domain_response|
      { answer_values: domain_response.answer_values,
        estimate: domain_response.estimate,
        variance: domain_response.variance,
        estimate_interpretation: domain_response.estimate_interpretation,
        warning: domain_response.warning }
    end
  end

  def questions
    next_question.present? ? completed_questions.push(next_question) : completed_questions
  end

  def completed_questions
    answers.map(&:question).flatten
  end

  def answers
    answer_values.map do |id, value|
      Answer.new id: id, value: value
    end
  end

  def answer_values
    Events::AnswerSet.answer_values_for(uuid)
  end

  def next_question
    Question.new id: next_question_id unless done
  end

  def invitation
    Invitation.find_by_response_uuid uuid
  end

  def invitation_accepted
    Events::InvitationAccepted.find_by response_uuid: uuid
  end

  def events
    Events::Event.where response_uuid: uuid
  end

  def self.find_by_show_secret(show_secret)
    invitation_accepted = Events::InvitationAccepted.find_by_show_secret show_secret
    find invitation_accepted.response_uuid
  end
end
