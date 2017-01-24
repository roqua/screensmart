describe ResponseSerializer do
  let(:invitation_accepted) { Fabricate :invitation_accepted }

  subject do
    response = Response.find(invitation_accepted.response_uuid)
    Events::AnswerSet.create! response_uuid: response.uuid,
                              question_id: 'EL02',
                              answer_value: 2

    JSON.parse(ResponseSerializer.new(response).to_json)['response']
  end

  it 'includes estimate, variance, estimate_interpretation, warning and questions' do
    invitation = Invitation.find_by_response_uuid(invitation_accepted.response_uuid)
    serialized = subject.with_indifferent_access

    expect(serialized[:uuid]).to eq(invitation_accepted.response_uuid)
    expect(serialized[:requested_at]).to eq(invitation.requested_at.iso8601)
    expect(serialized[:created_at]).to eq(invitation_accepted.created_at.iso8601)
    expect(serialized[:done]).to eq(false)
    expect(serialized[:domain_ids]).to eq(['POS-PQ'])

    expect(serialized[:questions]).to be_an(Array)
    question = serialized[:questions][0]
    expect(question).to include(:id, :text, :intro, :answer_value, :answer_option_set)
    expect(question[:id]).to eq('EL02')
    expect(question[:text]).to be_a(String)
    expect(question[:intro].class).to be_in([String, NilClass])
    expect(question[:answer_value]).to eq(2)
    expect(question[:answer_option_set]).to include(:id, :answer_options)
    expect(question[:answer_option_set][:answer_options][0]).to include(:id, :text)

    domain_result = serialized[:domain_results][0]
    expect(domain_result).to include(:estimate, :variance, :estimate_interpretation, :warning, :domain, :quartile)
    expect(domain_result[:estimate]).to be_a(Float)
    expect(domain_result[:variance]).to be_a(Float)
    expect(domain_result[:estimate_interpretation]).to be_a(String)
    expect(domain_result[:warning].class).to be_in([String, NilClass])
    expect(domain_result[:quartile]).to be_a(String)

    first_domain = serialized[:domain_results].first[:domain]
    expect(first_domain[:id]).to eq 'POS-PQ'
    expect(first_domain[:description]).to eq 'Positieve symptomen van psychose'
    expect(first_domain[:norm_population]).to eq 'Algemene bevolking'
  end
end
