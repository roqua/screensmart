describe 'sending invitations' do
  def fill_out_all_fields
    fill_in 'respondentEmail', with: 'some@patient.dev'
    fill_in 'requesterName', with: 'some@patient.dev'
    fill_in 'requesterEmail', with: 'some@patient.dev'
    find('.domain-label', text: 'Positieve symptomen van psychose').click
    find('.domain-label', text: 'Negatieve symptomen van psychose').click
  end

  before { visit '/' }

  scenario 'filling out all fields and submitting the form' do
    fill_out_all_fields

    click_on 'Verstuur uitnodiging'
    expect(page).not_to have_css '.error'
  end

  scenario 'not filling out all fields' do
    fill_out_all_fields
    fill_in 'respondentEmail', with: ''

    click_on 'Verstuur uitnodiging'
    expect(page).to have_css '.error'
    expect(page).to have_content 'Vul een geldig e-mailadres in'
  end

  scenario 'entering invalid values' do
    fill_out_all_fields
    fill_in 'respondentEmail', with: 'invalid'

    click_on 'Verstuur uitnodiging'
    expect(page).to have_css '.error'
    expect(page).to have_content 'Vul een geldig e-mailadres in'
  end
end
