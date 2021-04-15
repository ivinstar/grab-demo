# frozen_string_literal: true

require 'dry/monads'

module Grab
  class FileParser
    include Dry::Monads[:try, :result, :do]

    attr_reader :origin

    SEPARATOR = /\s/

    def initialize(origin)
      @origin = origin
    end

    def call
      yield is_file?

      url = ''
      result = []
      file = File.open(origin)
      file.each_char do |char|
        if SEPARATOR =~ char
          uri = Grab::Url.new(url)
          if uri.valid?.success?
            result << url
            url = ''
            next
          else
            next
          end
        else
          url += char
          result << url if file.eof?
        end

      end

      Success(result)
    end

    private

    def is_file?
      File.file?(origin) ? Success() : Failure(:not_a_regular_file_or_doesnt_exist)
    end

    def in_white_list?; end
  end
end