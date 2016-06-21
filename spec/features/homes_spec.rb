require 'rails_helper'

RSpec.feature 'Home', type: :feature do

  scenario 'Visiting home', js: true, focus: false do
    visit root_path
    expect(page).to have_text('Interleave')
  end
end
