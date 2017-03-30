# Value object that represents all test outcomes for a given domain
class DomainResult < BaseModel
  attr_accessor :domain_id, :estimate, :estimate_interpretation, :variance, :warning, :quartile

  def domain
    Domain.new id: domain_id
  end
end
