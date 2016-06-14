require 'rails_helper'

RSpec.feature "Homes", type: :feature do

  scenario "Visiting hoe",  js: true, focus: false do
    visit root_path
    expect(page).to have_text('Interleave')
  end
end
