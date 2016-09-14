describe AcceptInvitation do
  subject { described_class.run(params) }

  let(:invitation_sent) { Fabricate :invitation_sent }

  context 'with valid parameters' do
    let(:params) { { invitation_uuid: invitation_sent.invitation_uuid } }
    it 'creates an InvitationAccepted event' do
      expect { subject }.to change { Events::InvitationAccepted.count }.by(1)
    end
  end

  context 'invitation_uuid is missing' do
    let(:params) { { invitation_uuid: '' } }
    it { is_expected.to have(1).errors_on :invitation_uuid }
  end

  context 'response has already been finished' do
    let(:params) { { invitation_uuid: invitation_sent.invitation_uuid } }

    before do
      Events::ResponseFinished.create!(
        invitation_uuid: invitation_sent.invitation_uuid,
        response_uuid: SecureRandom.uuid
      )
    end

    it 'raises an exception' do
      expect { subject }.to raise_error AcceptInvitation::AlreadyFinished
    end
  end
end
