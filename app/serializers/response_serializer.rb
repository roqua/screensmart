class ResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :requested_at, :created_at, :domain_ids, :done,
             :domain_interpretations, :demo

  has_many :domain_results
  has_many :questions

  def demo
    object.invitation.demo?
  end
end

class DomainResultSerializer < ActiveModel::Serializer
  attributes :estimate, :variance

  has_one :domain
end

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :intro, :answer_value

  has_one :answer_option_set
end

class AnswerOptionSetSerializer < ActiveModel::Serializer
  attributes :id

  has_many :answer_options
end
