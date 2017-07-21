module FeatureHelpers
  # rubocop:disable MethodLength
  def sign_in(*args)
    if args.size == 2
      email = args[0]
      password = args[1]
    else
      email = args[0].email
      password = args[0].password
    end

    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end

  def sign_up(username, email, password)
    visit new_user_registration_path
    fill_in "Username", with: username
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password
    click_button "Sign up"
  end
end
