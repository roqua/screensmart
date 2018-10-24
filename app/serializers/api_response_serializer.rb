require_relative './response_serializer.rb'

class ApiResponseSerializer < ActiveModel::Serializer
  attributes :uuid, :requested_at, :created_at, :domain_ids, :done,
             :domain_interpretations, :demo, :show_secret

  has_many :domain_results
  has_many :questions

  def demo
    object.invitation.demo?
  end
end
