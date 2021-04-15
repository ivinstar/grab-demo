# frozen_string_literal: true

require 'fileutils'
require 'dry/monads'

module Grab
  class Folder
    include Dry::Monads[:try, :result, :do]

    attr_reader :dir

    def initialize(dir)
      @dir = dir
    end

    def call
      yield writable? if exists?.success?
      yield create

      Success(:upload_folder_is_ok)
    end

    private

    def exists?
      File.directory?(dir) ? Success(:ok) : Failure(:directory_doesnt_exist)
    end

    def writable?
      File.stat(dir).writable? ? Success(:ok) : Failure(:directory_doesnt_writable)
    end

    def create
      Try { FileUtils.mkdir_p dir, mode: 0755 }.to_result
    end
  end
end