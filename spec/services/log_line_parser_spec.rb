require 'spec_helper'

describe LogLineParser do

  context "data request" do
    let(:line) { "1366466401 0 176.206.33.0 745 93.184.214.38 80 TCP_EXPIRED_HIT/200 1189 GET http://cdn.sublimevideo.net/_.gif?i=1366466401&s=site1234&d=%5B%7B%22e%22%3A%22al%22%2C%22ho%22%3A%22m%22%2C%22st%22%3A%22s%22%2C%22dt%22%3A%22document+title%21%22%2C%22du%22%3A%22https%3A%2F%2Fdocument.com%3Fie%3DUTF8%26itemID%3D200137680%22%2C%22ru%22%3A%22http%3A%2F%2Freferrer.com%3Fbob%3D3%231%22%7D%2C%7B%22e%22%3A%22l%22%2C%22u%22%3A%22video_uid%22%2C%22de%22%3A%22m%22%2C%22te%22%3A%22h%22%2C%22du%22%3A%22https%3A%2F%2Fdocument.com%3Fie%3DUTF8%26itemID%3D200137680%22%2C%22ru%22%3A%22http%3A%2F%2Freferrer.com%3Fbob%3D3%231%22%7D%5D - 122 719 \"-\" \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25\" 33820 \"-\"" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq 1366466401 }
    its(:ip) { should eq '176.206.33.0' }
    its(:status) { should eq 200 }
    its(:method) { should eq 'GET' }
    its(:uri_stem) { should include 'http://cdn.sublimevideo.net/_.gif?' }
    its(:user_agent) { should eq 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25' }
    its(:site_token) { should eq 'site1234' }
    its(:data) { should be_kind_of(Array) }
    it { should be_data_request }
  end
end
