RSpec.shared_examples "a newspaper core presenter" do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:request) { double(host: 'example.org') }
  let(:user_key) { 'a_user_key' }

  let(:core_attributes) do
    { "alt_title" => ['There and Back Again'],
      "issn" => '2049-3630',
      "lccn" => '2001001114',
      "oclcnum" => 'ocm00012345',
      "held_by" => 'Marriott Library' }
  end

  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  it { is_expected.to delegate_method(:alt_title).to(:solr_document) }
  it { is_expected.to delegate_method(:issn).to(:solr_document) }
  it { is_expected.to delegate_method(:lccn).to(:solr_document) }
  it { is_expected.to delegate_method(:oclcnum).to(:solr_document) }
  it { is_expected.to delegate_method(:held_by).to(:solr_document) }
end
