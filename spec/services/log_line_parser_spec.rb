require 'spec_helper'

describe LogLineParser do

  context "data request" do
    let(:line) { "1366466401 0 176.206.33.0 745 93.184.214.38 80 TCP_EXPIRED_HIT/200 1189 GET http://cdn.sublimevideo.net/_.gif?i=1366466401&s=site1234&d=%5B%7B%22e%22%3A%22al%22%2C%22ho%22%3A%22m%22%2C%22st%22%3A%22s%22%2C%22dt%22%3A%22document+title%21%22%2C%22du%22%3A%22https%3A%2F%2Fdocument.com%3Fie%3DUTF8%26itemID%3D200137680%22%2C%22ru%22%3A%22http%3A%2F%2Freferrer.com%3Fbob%3D3%231%22%7D%2C%7B%22e%22%3A%22l%22%2C%22u%22%3A%22video_uid%22%2C%22de%22%3A%22m%22%2C%22te%22%3A%22h%22%2C%22du%22%3A%22https%3A%2F%2Fdocument.com%3Fie%3DUTF8%26itemID%3D200137680%22%2C%22ru%22%3A%22http%3A%2F%2Freferrer.com%3Fbob%3D3%231%22%7D%5D - 122 719 \"-\" \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25\" 33820" }
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

  context "old data request" do
    let(:line) { "1368605904 0 66.249.74.142 35 108.161.246.64 80 TCP_HIT/200 398 GET http://cdn.sublimevideo.net/_.gif?t=2xrynuh2&e=l&du=http%3A%2F%2Fwww.arhsinflight.com%2F2010%2F10%2F14%2F&em=1&eu=http%3A%2F%2Fwww.schooltube.com%2Fembed%2Fc327d6b4f2442587514a%2F&sr=1024x1024&bl=en&fv=10.1.53&pt%5B%5D=n&pm%5B%5D=f&pff%5B%5D=&pz%5B%5D=298x225&vu%5B%5D=c327d6b4f2442587514a&h=m&i=1340064000000&d=d&em=1 - 0 588 \"-\" \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq 1368605904 }
    it { should_not be_data_request }
  end

  context "non data request" do
    let(:line) { "1368605419 0 94.250.35.142 2474 46.22.75.231 80 TCP_EXPIRED_HIT/200 2868 GET http://cdn.sublimevideo.net/a/avo5qgqh/1/logo-custom-61x22-1355887767@2x.png - 90 785 \"-\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq 1368605419 }
    its(:uri_stem) { should include 'http://cdn.sublimevideo.net/a' }
    its(:user_agent) { should eq 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31' }
    it { should_not be_data_request }
  end

  context "request with no filesize" do
    let(:line) { "1368605176 0 81.215.91.112 - 108.161.243.145 80 TCP_HIT/304 384 GET http://cdn.sublimevideo.net/s/avo5qgqh.js - 0 567 \"-\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/25.0.1359.3 Safari/537.21\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq 1368605176 }
    its(:ip) { should eq '81.215.91.112' }
    its(:status) { should eq 304 }
    its(:method) { should eq 'GET' }
    it { should_not be_data_request }
  end
end
