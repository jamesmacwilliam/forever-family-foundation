require_relative 'feature_helper'

describe 'ADG registration' do

  before do
    @adg_question1 = AdgQuestion.create!(question: 'Do you Believe In GOD?', show_radio: true)
    @adg_question2 = AdgQuestion.create!(question: 'Do you believe that there is something that survives after physical death?', show_radio: true )
    @adg_question3 = AdgQuestion.create!(question: 'What specific topics are you interested in discussing?', show_radio: true )
    @adg_question4 = AdgQuestion.create!(question: 'What books have you read in this topic', show_radio: true )
    @user = FactoryGirl.create(:user)
  end

  it 'Answers ADG question by clicking the label of a radio button' do
    sign_in(@user)
    within '#site_nav' do
      click_link 'Afterlife Discussion Groups'
    end
    click_link 'Register'
    find('label.radio[for="adg_registration_radio_val[1]_yes"]').click
    find('label.radio[for="adg_registration_radio_val[2]_no"]').click
    #text area
    page.should have_selector '#adg_registration_answer_1', visible: true
    page.should_not have_selector '#adg_registration_answer_2', visible: true
  end

  it 'Answer ADG questions' do
    sign_in(@user)
    within '#site_nav' do
      click_link 'Afterlife Discussion Groups'
    end
    click_link 'Register'
    within('table.adg_questions tr:nth-child(1)') do
      choose 'Yes'
      fill_in "adg_registration[answer[#{@adg_question1.id}]]", with: 'some text here...'
    end

    within('table.adg_questions tr:nth-child(2)') do
      choose 'No'
    end

    within('table.adg_questions tr:nth-child(3)') do
      choose 'Yes'
      fill_in "adg_registration[answer[#{@adg_question3.id}]]", with: 'some text for topics here...'
    end

    within('table.adg_questions tr:nth-child(4)') do
      choose 'Yes'
      fill_in "adg_registration[answer[#{@adg_question4.id}]]", with: 'some text for books read here...'
    end

    click_on 'Submit'
    current_url.should match "/users/#{@user.id}"
  end

  it "User is redirected to registration if not logged-in" do
    pending 'remove redirects'
    visit('/')
    within '#site_nav' do
      click_link 'Afterlife Discussion Groups'
    end
    click_link 'Register'
    page.should have_content 'Login Info'
    fill_in_reg(email: 'test2@example.com')
    click_on 'Confirm'
    page.should have_content("Welcome")
    click_on 'Home'
    page.should have_content("Adg Registrations: New")
  end
end
