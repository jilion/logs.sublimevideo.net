require 'spec_helper'

describe Log do
  let(:log_filename) { 'wac_841C_20130420_0050.log.gz' }
  let(:log_file) { fixture_file(log_filename) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:file) }
  end

  describe "Indexes" do
    it { should have_db_index([:name, :provider]).unique(true) }
  end

  it "support log file via carrierwave" do
    Log.create(
      name: log_filename,
      provider: 'edgecast',
      file: log_file)
    log = Log.where(name: log_filename, provider: 'edgecast').first
    log.file.size.should eq log_file.size
  end
end

# == Schema Information
#
# Table name: logs
#
#  created_at  :datetime
#  file        :string(255)
#  id          :integer          not null, primary key
#  name        :string(255)
#  parsed_at   :datetime
#  parsed_line :integer
#  provider    :string(255)
#  updated_at  :datetime
#
# Indexes
#
#  index_logs_on_name_and_provider  (name,provider) UNIQUE
#

