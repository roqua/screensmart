describe SendInvitation do
  let(:params) { { requester_email: 'behandelaar@example.com', domain_ids: ['POS-PQ'] } }

  context 'with valid parameters' do
    subject { described_class.run!(params) }

    it 'stores Invitation_sent event' do
      expect { subject }.to change{
        Events::InvitationSent.count
      }.by(1)
    end

    it 'sets a uuid' do
      expect(subject.response_uuid).to be
    end
  end

  context 'with invalid parameters' do
    subject { described_class.run(params) }

    context 'requester_email is invalid' do
      it 'has an error on requester email' do
        params[:requester_email] = 'behandelaar'
        expect(subject).to have(1).errors_on(:requester_email)
      end
    end

    context 'domain is invalid' do
      it 'has an error on domain' do
        params[:domain_ids] = ['whatever']
        expect(subject).to have(1).errors_on(:domain_ids)
      end

      it 'has an error on empty domain_ids' do
        params[:domain_ids] = []
        expect(subject).to have(1).errors_on(:domain_ids)
      end
    end
  end
end
