# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/grab/*.rb'].each { |file| require file }

module Grab
  class << self
    include Dry::Monads[:try, :result, :do]

    attr_reader :origin, :download_to

    def call(origin:, download_to:)
      @origin, @download_to = origin, download_to

      on_success = ->(_) { handle_message(_) }
      on_failure = proc { |_err|
        handle_message(_err)
        return
      }

      # Check if download folder exists and writable
      Grab::Folder.new(download_to).call.either(on_success, on_failure)

      # Parse origin file and download
      Grab::Download.new(origin, download_to).call.either(on_success, on_failure)
    end

    private

    def handle_message(message)
      puts locals[message] || message.to_s
    end

    def locals
      {
        directory_doesnt_writable: "Directory is not writable",
        not_a_regular_file_or_doesnt_exist: "The origin file isn't a file or doesn't exist"
      }
    end
  end
end