# frozen_string_literal: true

require 'rspec'
require './lib/grab/url'

RSpec.describe Grab::Url do
  let(:url_1) { 'https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75552.jpg?w=636&h=424' }
  let(:url_2) { 'https://i.natgeo' }
  let(:url_3) { 'https://https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75552.jpg?w=636&h=424' }
  let(:url_4) { 'https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75' }
  let(:url_5) { 'https://:8080' }

  context '#valid?' do

    it "#url_1" do
      uri = described_class.new(url_1)
      expect(uri.valid?).to be_success
      expect(uri.filename).to be_success
    end

    it "#url_2" do
      uri = described_class.new(url_2)
      expect(uri.valid?).to be_failure
      expect(uri.filename).to be_failure
    end

    it "#url_3" do
      uri = described_class.new(url_3)
      expect(uri.valid?).to be_failure
      expect(uri.filename).to be_success
    end

    it "#url_4" do
      uri = described_class.new(url_4)
      expect(uri.valid?).to be_success
      expect(uri.filename).to be_failure
    end

    it "#url_5" do
      uri = described_class.new(url_5)
      expect(uri.valid?).to be_failure
      expect(uri.filename).to be_failure
    end
  end
end