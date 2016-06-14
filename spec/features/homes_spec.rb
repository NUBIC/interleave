require 'rails_helper'

RSpec.feature "Homes", type: :feature do

  scenario "Visiting hoe", focus: true, js: true do
    visit root_path
    expect(page).to have_text('Interleave')
  end
end
