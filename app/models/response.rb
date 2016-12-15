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

  def done
    domain_responses.all?(&:done)
  end

  def domain_responses
    domain_ids.map do |domain_id|
      DomainResponse.find(uuid, domain_id)
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

  def next_domain_response
    domain_responses.find do |domain_id|
      !domain_id.done
    end
  end

  def next_domain_id
    next_domain_response.try(:domain_id)
  end

  def questions
    next_question.present? ? completed_questions.push(next_question) : completed_questions
  end

  def completed_questions
    answers.map(&:question).flatten
  end

  def answers
    domain_responses.map(&:answers).flatten
  end

  def answer_values
    domain_responses.map(&:answer_values)
  end

  def next_question
    Question.new id: next_domain_response.next_question_id, domain_id: next_domain_id unless done
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
