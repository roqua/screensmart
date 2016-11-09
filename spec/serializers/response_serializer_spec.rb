describe ResponseSerializer do
  let(:invitation_accepted) { Fabricate :invitation_accepted }

  subject do
    response = Response.find(invitation_accepted.response_uuid)
    Events::AnswerSet.create! response_uuid: response.uuid,
                              question_id: 'EL02',
                              answer_value: 2

    JSON.parse(ResponseSerializer.new(response).to_json)['response']
  end

  def pretty(json)
    JSON.pretty_generate(json)
  end

  it 'includes estimate, variance, estimate_interpretation, warning and questions' do
    serialized = subject.with_indifferent_access

    expect(serialized[:uuid]).to eq(invitation_accepted.response_uuid)
    expect(serialized[:created_at]).to eq(invitation_accepted.created_at.iso8601)
    expect(serialized[:estimate]).to be_a(Float)
    expect(serialized[:variance]).to be_a(Float)
    expect(serialized[:estimate_interpretation]).to be_a(String)
    expect(serialized[:warning].class).to be_in([String, NilClass])
    expect(serialized[:done]).to be_falsey
    expect(serialized[:domain_ids]).to be_an(Array)
    expect(serialized[:domain_ids]).to eq(['POS-PQ'])
    expect(serialized[:questions]).to be_an(Array)
    expect(serialized[:questions][0]).to include(:id, :text, :intro, :answer_value, :answer_option_set)
    expect(serialized[:questions][0][:id]).to eq('EL02')
    expect(serialized[:questions][0][:text]).to be_a(String)
    expect(serialized[:questions][0][:intro].class).to be_in([String, NilClass])
    expect(serialized[:questions][0][:answer_value]).to eq(2)
    expect(serialized[:questions][0][:answer_option_set]).to include(:id, :answer_options)
    expect(serialized[:questions][0][:answer_option_set][:answer_options][0]).to include(:id, :text)

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
