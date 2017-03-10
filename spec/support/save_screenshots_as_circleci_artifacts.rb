def save_screenshots_as_circleci_artifacts
  Capybara.save_path = "#{ENV['CIRCLE_ARTIFACTS']}/screenshots" if ENV['CIRCLE_ARTIFACTS']
end
