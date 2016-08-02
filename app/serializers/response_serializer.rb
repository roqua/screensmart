class ResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :estimate, :variance, :done

  has_many :questions
end

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :intro, :answer_value

  has_one :answer_option_set
end

class AnswerOptionSetSerializer < ActiveModel::Serializer
  attributes :id

  has_many :answer_options
end
