describe 'choosing domains' do
  def answer_question(index, answer)
    within ".item:nth-child(#{index}) .question" do
      find('.option', text: answer).click
    end
  end

  def back_button
    page.evaluate_script('window.history.back()')
  end

  scenario 'clicking a domain' do
    visit '/'
    click_on 'Positieve symptomen voor psychose'
    expect(page).to have_content 'Vraag 1'
  end

  scenario 'going back and choosing a different domain' do
    # Start first response
    visit '/'
    click_on 'Positieve symptomen voor psychose'
    expect(page).to have_content 'Vraag 1'

    # Fill out a question
    answer_question 1, 'Eens'
    expect(page).to have_content 'Vraag 2'

    # Start over
    back_button
    click_on 'Positieve symptomen voor psychose'

    # expect previous answer to have been removed
    expect(page).to have_content 'Vraag 1'
    expect(page).not_to have_content 'Vraag 2'
  end
end
