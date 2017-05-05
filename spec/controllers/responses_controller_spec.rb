describe ResponsesController do
  include ExampleDemographicInfo
  let(:invitation_sent) { Fabricate :invitation_sent }

  describe '#create' do
    subject { post :create, params: { invitation_uuid: invitation_sent.invitation_uuid } }

    it 'accepts the invitation' do
      expect { subject }.to change { Events::InvitationAccepted.count }.by 1
    end
  end

  describe '#show' do
    let!(:invitation_accepted) do
      AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    end

    subject { get :show, params: { id: invitation_accepted.response_uuid } }

    it 'renders the response as JSON' do
      subject
      model = Response.find invitation_accepted.response_uuid
      expect(response.body).to eq ResponseSerializer.new(model).as_json.to_json
    end
  end

  describe '#update' do
    let!(:invitation_accepted) do
      AcceptInvitation.run! invitation_uuid: invitation_sent.invitation_uuid
    end

    before do
      %w(EL49 EL37 EL03 EL38).each do |question_id|
        Events::AnswerSet.create!(
          response_uuid: invitation_accepted.response_uuid,
          question_id: question_id,
          answer_value: 1
        )
      end
    end

    subject do
      put :update, params: { id: invitation_accepted.response_uuid,
                             demographic_info: demographic_info }
    end

    it 'finishes the response' do
      expect { subject }.to change { Events::ResponseFinished.count }.by 1
    end

    it 'sends the email' do
      expect(ResponseMailer).to receive(:response_email).and_call_original
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
