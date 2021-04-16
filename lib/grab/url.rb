# frozen_string_literal: true

require 'uri'
require 'open-uri'
require 'dry/monads'

module Grab
  class Url
    include Dry::Monads[:try, :result, :do]

    def initialize(url)
      @uri = URI.parse(url)
      @url = url
    end

    def valid?
      url_regexp = /^(http|https):\/\/\w+([\-\.]{1}\w+)*\.[a-z]{2,5}(:\d{1,5})?(\.[png|jpeg|jpg|gif])?(\/.*)?$/i

      url =~ url_regexp ? Success(:ok) : Failure(:url_is_bad)
    end

    def filename
      filename = File.basename(uri.path)
      /.\.(png|jpeg|jpg|gif)$/ =~ filename ? Success(filename) : Failure(:no_image)
    end

    private

    attr_reader :uri, :url

  end
end