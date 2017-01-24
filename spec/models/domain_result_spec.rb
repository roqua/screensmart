describe DomainResult do
  let(:invitation_accepted) { Fabricate(:invitation_accepted) }
  let(:response) { Response.find(invitation_accepted.response_uuid) }
  let(:domain_result) { DomainResult.new domain_id: response.domain_ids.first, response: response }

  describe '#data_from_r' do
    subject { domain_result.data_from_r }
    it 'returns a hash containing results for the DomainResult\'s domain_id' do
      expect(subject).to eq estimate: 0.0,
                            estimate_interpretation: 'Matig niveau (+)',
                            quartile: 'Q2',
                            variance: 25.0,
                            warning: nil
    end
  end

  describe '#quartile' do
    subject { domain_result.quartile }
    it 'returns the quartile belonging to the DomainResult\'s estimate_interpretation' do
      expect(subject).to eq 'Q2'
    end
  end
end
