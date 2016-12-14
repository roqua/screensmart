class ResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :created_at, :domain_ids, :done, :next_domain_id

  has_many :domain_responses
end

class DomainResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :domain_id, :estimate, :variance, :done, :estimate_interpretation, :warning

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
