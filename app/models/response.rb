# A stateless response to a given set of questions.
# Initializing is done by setting answer_values as a hash, for example:
#   r = Response.new(answer_values: { 'EL02' => 1 })
#
# After this, all attributes can be read in an OOP way, for example:
#   r.questions # All questions, including the next (unanswered) one
#   # => [#<Question:0x007faadb3459a8 @id="EL02", @answer_value: 1>,
#         #<Question:0x007faadb2d49d8 @id="EL03">]
class Response < BaseModel
  attr_accessor :answer_values, :domain_ids

  validates_with ResponseValidator

  # accessors for attributes defined by R package
  %i( next_question_id estimate variance done ).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        RPackage.data_for(answer_values, domain_ids)[r_attribute]
      end
    end
  end

  def initialize(attributes = {})
    super
    self.answer_values ||= {}
    self.domain_ids ||= []
  end

  def questions
    next_question.present? ? completed_questions.push(next_question) : completed_questions
  end

  def completed_questions
    answers.map(&:question)
  end

  def answers
    answer_values.map do |id, value|
      Answer.new id: id, value: value
    end
  end

  def next_question
    Question.new id: next_question_id unless done
  end
end
