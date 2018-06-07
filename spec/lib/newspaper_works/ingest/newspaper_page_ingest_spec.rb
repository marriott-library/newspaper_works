require 'spec_helper'
require 'faraday'

# test NewspaperPageIngest against work
RSpec.describe NewspaperWorks::Ingest::NewspaperPageIngest do
  # define the path to the file we will use for multiple examples
  let(:path) do
    fixtures = File.join(NewspaperWorks::GEM_PATH, 'spec/fixtures/files')
    File.join(fixtures, 'page1.tiff')
  end

  it_behaves_like('ingest adapter IO')

  describe "file import and attachment" do
    it "ingests file data and saves" do
      adapter = build(:newspaper_page_ingest)
      adapter.ingest(path)
      file_sets = adapter.work.members.select { |w| w.class == FileSet }
      expect(file_sets.size).to eq 1
      files = file_sets[0].files
      expect(files.size).to eq 1
      url = files[0].uri.to_s
      stored_size = Faraday.get(url).body.length
      expect(stored_size).to eq File.size(path)
      expect(file_sets[0].title).to contain_exactly 'page1.tiff'
    end
  end
end
