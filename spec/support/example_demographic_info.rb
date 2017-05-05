module ExampleDemographicInfo
  def self.included(base)
    base.let(:demographic_info) do
      { age: 18,
        education_level: 'vmbo',
        employment_status: 'fulltime',
        gender: 'female',
        relationship_status: 'living_together' }
    end
  end
end
