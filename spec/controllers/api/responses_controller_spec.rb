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

    before do
      SetAnswer.run! response_uuid: invitation_accepted.response_uuid, question_id: 'EL49', answer_value: 1
      SetAnswer.run! response_uuid: invitation_accepted.response_uuid, question_id: 'EL37', answer_value: 1
      SetAnswer.run! response_uuid: invitation_accepted.response_uuid, question_id: 'EL03', answer_value: 1
      SetAnswer.run! response_uuid: invitation_accepted.response_uuid, question_id: 'EL38', answer_value: 1
      FinishResponse.run! response_uuid: invitation_accepted.response_uuid
    end

    subject { get :show, params: {id: invitation_accepted.invitation_uuid} }

    it 'renders the completed response as JSON' do
      subject
      model = Response.find_by_invitation_uuid invitation_accepted.invitation_uuid
      expect(response.body).to eq ApiResponseSerializer.new(model).as_json.to_json
    end
  end
end
