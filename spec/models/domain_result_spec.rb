describe DomainResult do
  let(:invitation_accepted) { Fabricate(:invitation_accepted) }
  let(:response) { Response.find(invitation_accepted.response_uuid) }
  let(:domain_result) { DomainResult.new domain_id: response.domain_ids.first, response: response }

  describe '#data_from_r' do
    subject { domain_result.data_from_r }
    it 'returns a hash containing results for the DomainResult\'s domain_id' do
      expect(subject).to eq estimate: 0.0,
                            variance: 25.0,
                            domain_interpretations: {
                              'POS-PQ' => {
                                estimate_interpretation: 'Matig niveau (+)',
                                quartile: 'Q2',
                                warning: nil,
                                norm_population: 'Cliënten eerste lijn GGZ'
                              }
                            }
    end
  end
end
