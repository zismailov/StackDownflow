Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    # headless mode requires Chrome version 59 or newer
    # args: ["headless"],
  )
end
