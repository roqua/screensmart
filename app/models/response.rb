# A stateless response to a given set of questions.
# Initializing is done by setting answer_values as a hash, for example:
#   r = Response.new(answer_values: { 'EL02' => 1 })
#
# After this, all attributes can be read in an OOP way, for example:
#   r.questions # All questions, including the next (unanswered) one
#   # => [#<Question:0x007faadb3459a8 @key="EL02", @answer_value: 1>,
#         #<Question:0x007faadb2d49d8 @key="EL03">]
class Response < BaseModel
  attr_accessor :answer_values

  validates_with ResponseValidator

  # accessors for attributes defined by R package
  %i( next_question_key estimate variance done ).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        RPackage.data_for(answer_values)[r_attribute]
      end
    end
  end

  def initialize(attributes = {})
    super
    self.answer_values ||= {}
  end

  def questions
    next_question.present? ? completed_questions.push(next_question) : completed_questions
  end

  def completed_questions
    answers.map(&:question)
  end

  def answers
    answer_values.map do |key, value|
      Answer.new key: key, value: value
    end
  end

  def next_question
    Question.new key: next_question_key unless done
  end

  def without_answers_after(answer_key)
    remaining_answer_values = answer_values.each_with_object(result: [], found: false) do |(key, value), memo|
      unless memo[:found]
        memo[:result] << [key, value]
        memo[:found] = key == answer_key
      end
      memo
    end[:result].to_h

    self.class.new(answer_values: remaining_answer_values)
  end
end
