class Response
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations
  attr_accessor :answers

  validates_with ResponseValidator

  # accessors for attributes defined by R package
  %i( next_question_key estimate variance ).each do |r_attribute|
    define_method r_attribute do
      if valid?
        RPackage.data_for(answers)[r_attribute]
      else
        raise "Response must be valid when accessing `#{r_attribute}`.\n" \
              "Errors: #{errors.full_messages}"
      end
    end
  end

  def initialize(attributes = {})
    super
    self.answers ||= {}
  end

  def next_question
    Question.find_by_key next_question_key
  end

  def without_answers_after(answer_key)
    remaining_answers = answers.each_with_object(result: [], found: false) do |(key, value), memo|
      unless memo[:found]
        memo[:result] << [key, value]
        memo[:found] = true if key == answer_key
      end
      memo
    end[:result].to_h

    self.class.new(answers: remaining_answers)
  end
end
