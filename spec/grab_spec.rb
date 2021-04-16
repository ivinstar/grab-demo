# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Grab do
  let(:origin) { RSpec.configuration.origin_file }
  let(:download_to) { RSpec.configuration.download_folder }

  after { FileUtils.rm_rf(download_to) }

  context '#call' do
    before { described_class.call(origin: origin, download_to: download_to) }

    it "with success" do
      expect(Dir.empty?(download_to)).to be false
    end
  end

  context '#call' do
    before do
      FileUtils.mkdir_p download_to, mode: 0555
      described_class.call(origin: origin, download_to: download_to)
    end

    it "with failure" do
      expect(Dir.empty?(download_to)).to be true
    end
  end
end