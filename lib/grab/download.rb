# frozen_string_literal: true

require 'rest-client'
require 'dry/monads'

module Grab
  class Download
    include Dry::Monads[:try, :result, :do, :task]

    attr_reader :origin, :upload_to

    SEPARATOR = /\s/

    def initialize(origin, upload_to)
      @origin = origin
      @upload_to = upload_to
    end

    def call
      yield is_file?

      link = ''
      threads = []
      File.open(origin).each_char do |char|
        if SEPARATOR =~ char
          uri = Grab::Url.new(link)
          if uri.valid?.success?
            threads << download(uri)
            link = ''
            next
          end
        end
        link += char
      end
      threads.each(&:join)

      Success(:done)
    end

    private

    def is_file?
      File.file?(origin) ? Success() : Failure(:not_a_regular_file_or_doesnt_exist)
    end

    def download(uri)
      Thread.new(uri) do |thread|
        url ||= uri.url
        fetch_source(url).either(
          ->(_) {
            yield copy(_.file.path, "#{upload_to}/#{uri.filename.success}")
          },
          ->(_err) {}
        )
        p thread
      end

    end

    def fetch_source(url)
      Try do
        RestClient::Request.execute(
          method: :get,
          url: url,
          raw_response: true)
      end
        .to_result
    end

    def copy(src, dest)
      Try { FileUtils.mv(src, dest) }.to_result
    end

    def in_white_list?; end
  end
end