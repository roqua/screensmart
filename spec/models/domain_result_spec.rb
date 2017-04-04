describe DomainResult do
  let(:result) { DomainResult.new domain_id: 'POS-PQ' }

  describe '#domain' do
    subject { result.domain }

    it 'Returns the domain for the given domain_id' do
      expect(subject).to be_a Domain
      expect(subject.description).to eq 'Positieve symptomen van psychose'
    end
  end
end
