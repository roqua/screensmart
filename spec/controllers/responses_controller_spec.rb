describe ResponsesController do
  let(:model) { Response.find('c8d56681-03be-495e-a78d-472c84098e75') }

  before do
    Events::InvitationSent.create! response_uuid: model.uuid,
                                   requester_email: 'some@doctor.dev',
                                   domain_ids: ['POS-PQ']
  end

  describe '#show' do
    it 'renders the entire model as JSON' do
      get :show, id: model.uuid

      expect(response.body).to eq ResponseSerializer.new(model).as_json.to_json
    end
  end
end
