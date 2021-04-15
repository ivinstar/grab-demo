# frozen_string_literal: true

require 'uri'
require 'open-uri'
require 'dry/monads'

module Grab
  class Url
    include Dry::Monads[:try, :result, :do]

    attr_reader :uri, :url

    def initialize(url)
      @uri = URI.parse(url)
      @url = url
    end

    def valid?
      url_regexp = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i
      url =~ url_regexp ? Success(:ok) : Failure(:url_is_bad)
    end

    def filename
      Try { File.basename(uri.path) }.to_result
    end

    def normalize!(url); end

  end
end