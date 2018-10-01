require 'spec_helper'

describe Api::ResponsesController do
  let(:invitation_sent) { Fabricate :invitation_sent }

  describe '#create' do
    subject { post :create, params: {requester_name: 'test', requester_email: 'test', domain_ids: ['POS-PQ']} }

    it 'starts a new response' do
      expect { subject }.to change { Events::InvitationSent.count }.by 1
    end
  end

  describe '#show' do
    let!(:invitation_accepted) do
      AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    end

    subject { get :show, params: {id: invitation_accepted.show_secret} }

    it 'renders the response as JSON' do
      subject
      model = Response.find_by_show_secret invitation_accepted.show_secret
      expect(response.body).to eq ApiResponseSerializer.new(model).as_json.to_json
    end
  end
end
