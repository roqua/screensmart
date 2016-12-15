describe ResponseSerializer do
  let(:invitation_accepted) { Fabricate :invitation_accepted }

  subject do
    response = Response.find(invitation_accepted.response_uuid)
    Events::AnswerSet.create! response_uuid: response.uuid,
                              domain_id: 'POS-PQ',
                              question_id: 'EL02',
                              answer_value: 2

    JSON.parse(ResponseSerializer.new(response).to_json)['response']
  end

  def pretty(json)
    JSON.pretty_generate(json)
  end

  it 'includes estimate, variance, estimate_interpretation, warning and questions' do
    invitation = Invitation.find_by_response_uuid(invitation_accepted.response_uuid)
    serialized = subject.with_indifferent_access

    expect(serialized[:uuid]).to eq(invitation_accepted.response_uuid)
    expect(serialized[:requested_at]).to eq(invitation.requested_at.iso8601)
    expect(serialized[:created_at]).to eq(invitation_accepted.created_at.iso8601)
    expect(serialized[:done]).to eq(false)
    expect(serialized[:domain_ids]).to eq(['POS-PQ'])
    expect(serialized[:next_domain_id]).to eq('POS-PQ')

    expect(serialized[:questions]).to be_an(Array)
    question = serialized[:questions][0]
    expect(question).to include(:id, :domain_id, :text, :intro, :answer_value, :answer_option_set)
    expect(question[:id]).to eq('EL02')
    expect(question[:domain_id]).to eq('POS-PQ')
    expect(question[:text]).to be_a(String)
    expect(question[:intro].class).to be_in([String, NilClass])
    expect(question[:answer_value]).to eq(2)
    expect(question[:answer_option_set]).to include(:id, :answer_options)
    expect(question[:answer_option_set][:answer_options][0]).to include(:id, :text)

    domain_response = serialized[:domain_responses][0]
    expect(domain_response).to include(:estimate, :variance, :estimate_interpretation, :warning, :domain_id,
                                       :quartile, :domain_sign, :norm_population_label)
    expect(domain_response[:estimate]).to be_a(Float)
    expect(domain_response[:variance]).to be_a(Float)
    expect(domain_response[:estimate_interpretation]).to be_a(String)
    expect(domain_response[:warning].class).to be_in([String, NilClass])
    expect(domain_response[:domain_id]).to eq('POS-PQ')
    expect(domain_response[:quartile]).to be_a(String)
    expect(domain_response[:domain_sign]).to eq('neg')
    expect(domain_response[:norm_population_label]).to eq('Cliënten eerste lijn GGZ')

    # TODO: Remove if we settle for above test
    # expect(pretty(subject)).to eq(pretty({
    #   uuid: invitation_accepted.response_uuid,
    #   created_at: invitation_accepted.created_at.iso8601,
    #   estimate: 0.7,
    #   variance: 0.6,
    #   done: false,
    #   questions: [{
    #     id: 'EL02',
    #     text: 'Vraag 1',
    #     intro: 'Geef a.u.b. antwoord voor de afgelopen 7 dagen.',
    #     answer_value: 2,
    #     answer_option_set: {
    #       id: 2,
    #       answer_options: [
    #         {
    #           id: 1,
    #           text: 'Oneens'
    #         },
    #         {
    #           id: 2,
    #           text: 'Eens'
    #         }
    #       ]
    #     }
    #   }, {
    #     id: 'EL03',
    #     text: 'Vraag 2',
    #     intro: '',
    #     answer_value: nil,
    #     answer_option_set: {
    #       id: 2,
    #       answer_options: [
    #         {
    #           id: 1,
    #           text: 'Oneens'
    #         },
    #         {
    #           id: 2,
    #           text: 'Eens'
    #         }
    #       ]
    #     }
    #   }
    #   ]
    # }.with_indifferent_access))
  end
end
