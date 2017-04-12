class DomainInterpretationSerializer < ActiveModel::Serializer
  attributes :interpretation_domain_id, :description, :norm_population, :quartile, :estimate_interpretation
end
