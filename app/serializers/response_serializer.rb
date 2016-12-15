class ResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :requested_at, :created_at, :domain_ids, :done, :next_domain_id

  has_many :domain_responses
  has_many :questions
end

class DomainResponseSerializer < ActiveModel::Serializer
  attributes :domain_id, :estimate, :variance, :estimate_interpretation, :warning,
             :quartile, :domain_sign, :norm_population_label
end

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :domain_id, :text, :intro, :answer_value

  has_one :answer_option_set
end

class AnswerOptionSetSerializer < ActiveModel::Serializer
  attributes :id

  has_many :answer_options
end
