describe Invitation do
  let(:invitation_sent) { Fabricate :invitation_sent }

  let!(:invitation_accepted) do
    AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
  end

  describe '#domain_ids' do
    subject { described_class.find invitation_sent.invitation_uuid }
    it 'returns the domains from the InvitationSent event' do
      expect(subject.domain_ids).to eq ['POS-PQ']
    end
  end

  describe '.find_by_response_uuid' do
    subject { described_class.find_by_response_uuid invitation_accepted.response_uuid }

    it 'returns the invitation with the given response_uuid' do
      expect(subject.uuid).to eq invitation_accepted.invitation_uuid
    end
  end

  describe '#events' do
    let(:event) do
      Events::InvitationSent.create! invitation_uuid: SecureRandom.uuid,
                                     requester_email: 'requester@example.dev',
                                     domain_ids: ['POS-PQ']
    end

    subject { described_class.find(event.invitation_uuid).events }

    it { is_expected.to eq [event] }
  end
end
