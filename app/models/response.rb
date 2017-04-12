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
  delegate :show_secret, :created_at, to: :invitation_accepted
  delegate :domain_ids, :requested_at, to: :invitation

  # accessors for attributes defined by R package
  %i(next_question_id done).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        data_from_r[r_attribute]
      end
    end
  end

  def data_from_r
    @data_from_r ||= RPackage.data_for(answer_values, domain_ids)
  end

  def domain_results
    @domain_results ||= domain_ids.map do |domain_id|
      DomainResult.new(response: self, domain_id: domain_id)
    end
  end

  def domain_interpretations
    domain_results.each_with_object([]) do |domain_result, interpretations|
      domain = domain_result.domain
      domain_result.domain_interpretations.values.each do |domain_interpretation|
        interpretations << { description: domain.description,
                             norm_population: domain_interpretation['norm_population'],
                             quartile: domain_interpretation['quartile'],
                             estimate_interpretation: domain_interpretation['estimate_interpretation'] }
      end
    end
  end

  def results
    domain_results.map(&:to_h)
  end

  def domains
    domain_results.map(&:id)
  end

  def questions
    @questions ||= (next_question.present? ? completed_questions.push(next_question) : completed_questions)
  end

  def completed_questions
    answers.map(&:question)
  end

  def answers
    @answers ||= answer_values.map do |id, value|
      Answer.new id: id, value: value
    end
  end

  def answer_values
    @answer_values ||= Events::AnswerSet.answer_values_for(uuid)
  end

  def next_question
    Question.new id: next_question_id unless done
  end

  def invitation
    @invitation ||= Invitation.find_by_response_uuid uuid
  end

  def invitation_accepted
    @invitation_accepted ||= Events::InvitationAccepted.find_by response_uuid: uuid
  end

  def events
    @events ||= Events::Event.where response_uuid: uuid
  end

  def self.find_by_show_secret(show_secret)
    invitation_accepted = Events::InvitationAccepted.find_by_show_secret show_secret
    find invitation_accepted.response_uuid
  end
end
