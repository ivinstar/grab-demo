# frozen_string_literal: true

require 'dotenv'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

Dotenv.load

origin_file = ENV['ORIGIN_FILE']
download_folder = ENV['DOWNLOAD_FOLDER']

Grab.call(origin: origin_file, download_to: download_folder)