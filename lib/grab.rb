# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/grab/*.rb'].each { |file| require file }

module Grab
  class << self
    include Dry::Monads[:try, :result, :do]

    attr_accessor :origin, :upload_to

    def call(origin:, upload_to:)
      @origin, @upload_to = origin, upload_to

      # Проверяем исходный файл
      Grab::Folder.new(upload_to).call.either(
        ->(_) { p 'ok' },
        ->(err) { p err }
      )
      # Проверяем папку результата
      # Загружаем изображения
    end
  end
end