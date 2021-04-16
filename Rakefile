# frozen_string_literal: true

require 'rake'
require 'dotenv'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

Dotenv.load

task :download do
  origin_file = ENV['ORIGIN_FILE']
  upload_folder = ENV['UPLOAD_FOLDER']

  Grab.call(origin: origin_file, upload_to: upload_folder)
end