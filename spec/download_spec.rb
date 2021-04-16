# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Grab::Download do
  let(:origin_file) { RSpec.configuration.origin_file }
  let(:download_to) { RSpec.configuration.download_folder }
  let(:class_instance) { Grab::Download.new(origin_file, download_to) }

  before { FileUtils.mkdir_p download_to, mode: 0755 }
  after { FileUtils.rm_rf(download_to) }

  context '#is_file?' do
    let(:file) { 'test_data.txt' }
    let(:class_instance_1) { Grab::Download.new(file, download_to) }

    it  do
      expect(class_instance.is_file?).to be_success
      expect(class_instance_1.is_file?).to be_failure
    end
  end

  context '#fetch_source' do
    let(:url_1) { 'https://i.natgeofe.com/n/9135' }
    let(:url_2) { 'https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75552.jpg?w=636&h=424' }

    it do
      VCR.use_cassette("download/url_1") do
        expect(class_instance.fetch_source(url_1)).to be_failure
      end
      VCR.use_cassette("download/url_2") do
        expect(class_instance.fetch_source(url_2)).to be_success
      end
    end
  end

  context '#copy' do
    let(:tmpfile) { Tempfile.new(File.basename(rand(-100).to_s), Dir.tmpdir) }
    let(:filename) { "#{download_to}/#{rand(-100).to_s}" }
    let(:filename_1) { "images_1/#{rand(-100).to_s}" }
    let(:class_instance_1) { Grab::Download.new(origin_file, 'images_1') }

    it do
      expect(class_instance.copy(tmpfile, filename)).to be_success
      expect(class_instance_1.copy(tmpfile, filename_1)).to be_failure
    end
  end

  context '#download' do
    let(:url_1) { 'https://i.natgeofe.com/n/9135' }
    let(:uri) { uri = Grab::Url.new(url_1) }

    it do
      expect(class_instance.download(uri)).to a_kind_of(Thread)
    end
  end
end