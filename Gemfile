source "http://rubygems.org"
gem "rails", "3.1.3"
gem "sass-rails"
gem "jquery-rails"
gem "compass"
gem "unicorn"

group :production, :staging do
  gem "pg"
end

group :development, :test do
  gem "sqlite3-ruby", "~> 1.3.0", :require => "sqlite3"
  gem "rspec-rails"
  gem "capybara"
end
