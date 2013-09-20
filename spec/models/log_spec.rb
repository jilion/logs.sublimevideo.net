require 'spec_helper'

describe Log do
  let(:log_file) { fixture_file('wac_841C_20130420_0050.log.gz') }
  let(:log) { create(:log, file: log_file) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:file) }
  end

  describe "Indexes" do
    it { should have_db_index([:name, :provider]).unique(true) }
  end

  it "support log file via carrierwave" do
    log_id = log.id
    log = Log.find(log_id)
    expect(log.file.size).to eq log_file.size
  end

  describe "#log_file" do
    it "returns log file" do
      log.log_file do |file|
        expect(file).to be_kind_of(LogFile)
        expect(file.size).to eq log_file.size
      end
    end
  end
end

# == Schema Information
#
# Table name: logs
#
#  created_at :datetime
#  file       :string(255)
#  id         :integer          not null, primary key
#  name       :string(255)
#  provider   :string(255)
#  read_at    :datetime
#  read_lines :integer          default(0)
#  updated_at :datetime
#
# Indexes
#
#  index_logs_on_name_and_provider  (name,provider) UNIQUE
#

