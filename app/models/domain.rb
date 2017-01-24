class Domain < BaseModel
  attr_accessor :id

  # accessors for attributes defined by R package
  %w(description norm_population).each do |r_attribute|
    define_method r_attribute do
      data_from_r[r_attribute]
    end
  end

  def data_from_r
    RPackage.domains.find { |domain| domain['id'] == id } || raise("Can't find domain with id #{id}")
  end
end
