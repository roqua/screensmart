describe SendInvite do
  let(:params) { { requester_email: 'behandelaar@example.com', domains: ['POS-PQ'] } }

  context 'with valid parameters' do
    subject { SendInvite.run!(params) }

    it 'stores invite_sent event' do
      expect { subject }.to change{
        Events::InviteSent.count
      }.by(1)
    end

    it 'sets a uuid' do
      expect(subject.response_uuid).to be
    end
  end

  context 'with invalid parameters' do
    subject { SendInvite.run(params) }

    context 'requester_email is invalid' do
      it 'has an error on requester email' do
        params[:requester_email] = 'behandelaar'
        expect(subject).to have(1).errors_on(:requester_email)
      end
    end

    context 'domain is invalid' do
      it 'has an error on domain' do
        params[:domains] = ['whatever']
        expect(subject).to have(1).errors_on(:domains)
      end
    end
  end

end
