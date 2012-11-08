require File.expand_path '../../../app/models/name_normalizer', __FILE__
describe NameNormalizer do
  let(:bad_name) { "hERP dERP-zurp" }
  let(:good_name) { "Herp Derp-zurp" }

  subject { NameNormalizer.run(bad_name) }
  it {should eq good_name}
end
