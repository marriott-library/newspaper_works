# Generated via
#  `rails generate hyrax:work NewspaperTitle`
require 'spec_helper'
require 'model_shared'

RSpec.describe NewspaperTitle do
  let(:fixture) { model_fixtures(described_class) }

  # shared behaviors
  it_behaves_like('a work and PCDM object')
  it_behaves_like('a persistent work type')

  describe 'Metadata and properties' do
    it 'class has expected properties' do
      expect(fixture).to respond_to(:edition)
      expect(fixture).to respond_to(:frequency)
      expect(fixture).to respond_to(:preceded_by)
      expect(fixture).to respond_to(:succeeded_by)
      expect(fixture).to respond_to(:publication_date_start)
      expect(fixture).to respond_to(:publication_date_end)
    end
  end

  describe 'Relationship methods' do
    it 'has expected test fixture' do
      expect(fixture).to be_an_instance_of(described_class)
    end

    it 'can get issues' do
      issues = fixture.issues
      expect(issues).to be_an_instance_of(Array)
      # our test fixture is non-empty
      expect(issues.length).to be > 0
      issues.each do |e|
        expect(e).to be_an_instance_of(NewspaperIssue)
      end
    end
  end

  it 'can get containers' do
    containers = fixture.containers
    expect(containers).to be_an_instance_of(Array)
    expect(containers.length).to be > 0
    containers.each do |e|
      expect(e).to be_an_instance_of(NewspaperContainer)
    end
  end

  describe 'publication_date_start' do
    it "is not valid with bad date format" do
      nt = NewspaperTitle.new(title: ["Breaking News!"],
                              publication_date_start: "06/21/1978")
      expect(nt).to_not be_valid
    end

    it "is valid with proper date format" do
      nt = NewspaperTitle.new(title: ["Breaking News!"],
                              publication_date_start: "1978-06-21")
      expect(nt).to be_valid
    end
  end

  describe 'publication_date_end' do
    it "is not valid with bad date format" do
      nt = NewspaperTitle.new(title: ["Breaking News!"],
                              publication_date_end: "06/21/1978")
      expect(nt).to_not be_valid
    end

    it "is valid with proper date format" do
      nt = NewspaperTitle.new(title: ["Breaking News!"],
                              publication_date_end: "1978-06-21")
      expect(nt).to be_valid
    end
  end

end
