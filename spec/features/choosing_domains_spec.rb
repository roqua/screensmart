describe 'choosing domains' do
  scenario 'clicking a domain' do
    visit '/'
    click_on 'Positieve symptomen voor psychose'
    expect(page).to have_content 'Vraag 1'
  end
end
