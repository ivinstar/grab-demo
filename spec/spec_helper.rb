# frozen_string_literal: true

require 'dotenv'
require 'rspec'
require 'tempfile'

require './lib/grab/url'
require './lib/grab'
require './lib/grab/folder'
require './lib/grab/download'

Dotenv.load('.env.test')

RSpec.configure do |config|
  config.add_setting(:origin_file, default: ENV['ORIGIN_FILE'])
  config.add_setting(:download_folder, default: ENV['DOWNLOAD_FOLDER'])
end