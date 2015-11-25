feature 'Highlighting' do
  background do
    visit root_path
    fill_in 'Search...', with: 'fish'
    click_button 'Search'
  end

  it 'contains the highlighed title' do
    expect(page.all('em', text: 'fish').first).not_to be_nil
  end
end