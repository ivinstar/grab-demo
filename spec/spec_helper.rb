# frozen_string_literal: true

require 'dotenv'
require 'rspec'
require 'tempfile'
require 'vcr'

require './lib/grab/url'
require './lib/grab'
require './lib/grab/folder'
require './lib/grab/download'

Dotenv.load('.env.test')

RSpec.configure do |config|
  config.add_setting(:origin_file, default: ENV['ORIGIN_FILE'])
  config.add_setting(:download_folder, default: ENV['DOWNLOAD_FOLDER'])
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end