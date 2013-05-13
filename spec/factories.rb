FactoryGirl.define do

  factory :log do
    name      'wac_841C_20130420_0050.log.gz'
    provider  'edgecast'
    file      { File.new(Rails.root.join('spec/fixtures', name)) }
  end

end
