describe SendInvite do
  subject { SendInvite.run!(params) }

  context 'with valid parameters' do
    let(:params) { { requester_email: 'behandelaar@example.com', domains: ['POS-PQ'] } }

    it 'stores invite_sent event' do
      expect { subject }.to change{
        Events::InviteSent.count
      }.by(1)
    end
  end

end
