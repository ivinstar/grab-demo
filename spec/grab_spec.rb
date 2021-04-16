# frozen_string_literal: true

require 'rspec'
require './lib/grab'

RSpec.describe Grab do
  let(:origin) { 'spec/test_data.txt' }
  let(:upload_to) { 'images_test' }

  after { FileUtils.rm_rf(upload_to) }

  context '#call' do
    before { described_class.call(origin: origin, upload_to: upload_to) }

    it "with success" do
      expect(Dir.empty?(upload_to)).to be false
    end
  end

  context '#call' do
    before do
      FileUtils.mkdir_p upload_to, mode: 0555
      described_class.call(origin: origin, upload_to: upload_to)
    end

    it "with failure" do
      expect(Dir.empty?(upload_to)).to be true
    end
  end
end