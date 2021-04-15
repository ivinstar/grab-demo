# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/grab/*.rb'].each { |file| require file }

module Grab
  class << self
    include Dry::Monads[:try, :result, :do]

    attr_reader :origin, :upload_to

    def call(origin:, upload_to:)
      # Use dry validation
      @origin, @upload_to = origin, upload_to

      on_success = ->(_) { handle_message(_) }
      on_failure = Proc.new { |_err|
        handle_message(_err)
        return
      }

      # Check if upload folder exists and writable
      Grab::Folder.new(upload_to).call.either(on_success, on_failure)

      # Parse origin file and upload
      Grab::FileParser.new(origin).call.either(
        ->(_v) { p _v },
        ->(_err) { p _err }
      )
    end

    private

    def handle_message(message)
      p locals[message] || message
    end

    def locals
      {
        directory_doesnt_writable: "Directory doesn't writable"
      }
    end
  end
end