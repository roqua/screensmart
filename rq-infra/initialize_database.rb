#!/usr/bin/env ruby

require 'fileutils'

init_filename = '/cache/development-db-was-initialized'

unless File.exist?(init_filename)
  system('bundle exec rake db:create && bundle exec rake db:setup') &&
    FileUtils.touch(init_filename)
end
