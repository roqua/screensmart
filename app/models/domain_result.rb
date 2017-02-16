# Value object that represents all test outcomes for a given domain
class DomainResult < BaseModel
  attr_accessor :domain_id, :response
  alias_attribute :to_h, :data_from_r

  # accessors for attributes defined by R package
  %i(estimate estimate_interpretation variance warning quartile).each do |r_attribute|
    define_method r_attribute do
      data_from_r[r_attribute]
    end
  end

  def domain
    Domain.new id: domain_id
  end

  def data_from_r
    @data_from_r ||= response.data_from_r[:domain_results][domain_id]
  end
end
