class DomainsSerializer < ActiveModel::Serializer
  has_many :domains
end

class DomainSerializer < ActiveModel::Serializer
  attributes :id, :name
end
