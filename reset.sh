#!/bin/sh

bundle exec rails db:environment:set RAILS_ENV=development

bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed



