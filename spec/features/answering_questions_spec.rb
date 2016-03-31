describe 'answering questions', vcr: { cassette_name: 'screensmart', allow_playback_repeats: true,
                                       match_requests_on: [:body, :uri, :method] } do
  def answer_newest_question
    find('.question:last-child .option:last-child').click
  end

  scenario 'answering a question' do
    visit '/'
    answer_newest_question
    expect(page).to have_content 'Vraag 2'
  end
end
