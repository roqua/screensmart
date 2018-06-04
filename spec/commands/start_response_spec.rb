describe StartResponse do
  let(:params) do
    {requester_name: 'Some Doctor',
     requester_email: 'requester@example.dev',
     respondent_email: 'patient@example.dev',
     domain_ids: ['POS-PQ']}
  end

  context 'with valid parameters' do
    subject { described_class.run!(params) }

    it 'stores InvitationSent event' do
      expect { subject }.to change {
        Events::InvitationSent.count
      }.by(1)
    end

    it 'sets a uuid' do
      expect(subject.invitation_uuid).to be
    end
  end

  context 'with invalid parameters' do
    subject { described_class.run(params) }

    context 'requester_name is invalid' do
      it 'has an error on requester name' do
        params[:requester_name] = ''
        expect(subject).to have(1).errors_on(:requester_name)
      end
    end

    context 'requester_email is invalid' do
      it 'has an error on requester email' do
        params[:requester_email] = ''
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
