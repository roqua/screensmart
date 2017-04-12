class Domain < BaseModel
  attr_accessor :id

  # accessors for attributes defined by R package
  def description
    data_from_r['description']
  end

  def data_from_r
    RPackage.domains.find { |domain| domain['id'] == id } || raise("Can't find domain with id #{id}")
  end
end
