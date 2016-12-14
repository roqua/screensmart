# A stateless response to a given set of questions.
# Initializing is done by setting answer_values as a hash, for example:
#   r = Response.new(answer_values: { 'EL02' => 1 })
#
# After this, all attributes can be read in an OOP way, for example:
#   r.questions # All questions, including the next (unanswered) one
#   # => [#<Question:0x007faadb3459a8 @id="EL02", @answer_value: 1>,
#         #<Question:0x007faadb2d49d8 @id="EL03">]
class DomainResponse < BaseModel
  attr_accessor :uuid, :domain_id

  # Accessors for attributes defined by events
  # delegate :show_secret, to: :invitation_accepted
  # delegate :created_at, to: :invitation_accepted
  delegate :domain_ids, to: :invitation

  # accessors for attributes defined by R package
  %i( next_question_id estimate variance done estimate_interpretation warning ).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        RPackage.data_for(answer_values, [domain_id])[r_attribute]
      end
    end
  end

  def questions
    next_question.present? ? completed_questions.push(next_question) : completed_questions
  end

  def completed_questions
    answers.map(&:question)
  end

  def answers
    answer_values.map do |id, value|
      Answer.new id: id, domain_id: domain_id, value: value
    end
  end

  def answer_values
    Events::AnswerSet.answer_values_for(uuid, domain_id)
  end

  def next_question
    Question.new id: next_question_id, domain_id: domain_id unless done
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

  def response
    Response.find(uuid)
  end

  # Finder method that ensures there are events for the given UUID
  def self.find(uuid, domain_id)
    new(uuid: uuid, domain_id: domain_id).tap do |model|
      raise "No events for #{model.class} with UUID #{model.uuid} and domain #{model.domain_id}" unless model.events.any?
    end
  end

  def self.exists?(uuid, domain_id)
    new(uuid: uuid, domain_id: domain_id).events.any?
  end

  # def self.find_by_show_secret(show_secret)
  #   invitation_accepted = Events::InvitationAccepted.find_by_show_secret show_secret
  #   find invitation_accepted.response_uuid
  # end
end
