describe InvitationsController do
  describe '#create' do
    let(:valid_params) do
      {
        respondent_email: 'test@example.com',
        requester_email: 'test2@example.com',
        domain_ids: ['POS-PQ']
      }
    end

    context 'with valid params' do
      it 'returns status created' do
        post :create, valid_params
        expect(response.status).to eq 201
      end

      it 'creates the invitation_sent event' do
        expect { post :create, valid_params }.to change { Events::InvitationSent.count }.by(1)
      end

      it 'sends the email'
    end

    context 'missing params' do
      it 'returns status bad request' do
        post :create, {}
        expect(response.status).to eq 400
      end
    end
  end
end
