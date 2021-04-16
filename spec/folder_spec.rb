# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Grab::Folder do
  let(:dir) { RSpec.configuration.download_folder }

  after { FileUtils.rm_rf(dir) }

  context '#call with success' do

    it "if dir folder doesn't exist returns success" do
      expect(described_class.new(dir).call).to be_success
      expect(File.directory?(dir)).to be true
    end
  end

  context '#call with failure' do

    let(:dir) { 'test/images_test' }

    before { FileUtils.mkdir_p 'test', mode: 0555 }

    it "if dir folder doesn't exist returns failure" do
      expect(described_class.new(dir).call).to be_failure
      expect(File.directory?(dir)).to be false
    end
  end
end