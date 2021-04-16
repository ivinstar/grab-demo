# frozen_string_literal: true

require 'rest-client'
require 'dry/monads'

module Grab
  class Download
    include Dry::Monads[:try, :result, :do, :task]

    SEPARATOR = /\s/

    def initialize(origin, download_to)
      @origin = origin
      @download_to = download_to
    end

    def call
      yield is_file?

      link = ''
      threads = []
      f = File.open(origin)
      f.each_char do |char|
        if SEPARATOR =~ char
          uri = Grab::Url.new(link)
          if uri.valid?.success?
            threads << download(uri)
            link = ''
            next
          end
        end
        link += char
        if f.eof?
          uri = Grab::Url.new(link)
          threads << download(uri) if f.eof?
        end
      end
      threads.each(&:join)

      Success(:done)
    end

    private

    attr_reader :origin, :download_to

    def is_file?
      File.file?(origin) ? Success() : Failure(:not_a_regular_file_or_doesnt_exist)
    end

    def download(uri)
      thr= Thread.new(uri) do |thread|
        url ||= uri.url
        fetch_source(url).either(
          ->(_) {
            yield copy(_.file.path, "#{download_to}/#{uri.filename.success}")
          },
          ->(_err) {}
        )
        p thread
      end
      thr
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
  end
end