class DomainInterpretationSerializer < ActiveModel::Serializer
  attributes :description, :norm_population, :quartile, :estimate_interpretation
end
