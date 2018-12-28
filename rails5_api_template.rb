## Rails5 template
##
## examples Generate with template
##   $ rails new my_app -T --skip-bundle -m https://github.com/arisanagao/rails_templates/blob/master/rails5_template.rb
##



## Create and initialize Git repository.
git :init
git add: '.'
git commit: '-a -m "first commit."'

## Update gem source.
gsub_file 'Gemfile', /^(gem 'tzinfo-data'.*)$/, ''

gem_group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'faker'
end

gem_group :development do
  gem 'brakeman', require: false
  gem 'rails_best_practices'
  # gem 'bullet'
end

gem_group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end

## Execute bundle install
run 'bundle install'

# Download .rubocop.yml
run 'curl https://raw.githubusercontent.com/sc1scc3/t_hama-docs/master/rubocop%E3%81%AB%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF/Rails%E7%94%A8_%E8%BE%9B%E5%8F%A3/.rubocop.yml?token=AfL-ULg9iWdegGp0VrZjxFaHLm2CqiC4ks5cLGMHwA%3D%3D > .rubocop.yml'
run 'rubocop --auto-correct --only Style/FrozenStringLiteralComment'
run 'rubocop --auto-correct --only Style/StringLiterals'
run 'rubocop --auto-correct --only Style/SymbolArray'
run 'rubocop --auto-correct --only Layout/EmptyLines'
run 'rubocop --auto-correct --only Layout/SpaceInsideArrayLiteralBrackets'

git add: '.'
git commit: '-a -m "auto correct rubocop"'

## Configure git.
append_file '.gitignore', <<-CODE
*.swp
core
.ruby-gemset.*
.ruby-version.*
.DS_Store
config/database.yml
config/cable.yml
coverage
.env
CODE



file 'Dockerfile', <<-"CODE"
FROM ruby:2.5.3-alpine
ENV APP_ROOT /var/rails
ENV TZ JST-9
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 3000
ENV RAILS_ENV production
# ARG RAILS_MASTER_KEY
# ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
ARG VERSION
ENV VERSION ${VERSION}
# ENV DATABASE_URL mysql2://root:mysql123@db/template_sample?reconnect=true

RUN apt-get update -qq && apt-get install -y build-essential
RUN gem update && gem install bundler --no-document

RUN mkdiri -p $APP_ROOT
WORKDIR $APP_ROOT
COPY Gemfile* ./
RUN bundle install --deployment --without development test
ADD . $APP_ROOT
EXPOSE $PORT
CMD bundle exec rails s -p $PORT -b '0.0.0.0' -e $RAILS_ENV
CODE


file 'docker-compose.yml', <<-"CODE"

