require 'spec_helper'

RSpec.describe NewspaperWorks::Ingest::UUArticleSegmented::IssueIngest do
  include_context 'ingest test fixtures'

  let(:dnews) { File.join(article_segmented, 'batch_deseret_news') }

  let(:page_path) { File.join(dnews, 'pages', 'p008_Va_071_D45_v01.xml') }

  let(:issue_path) { File.join(dnews, 'unit.xml') }

  let(:issue) { described_class.new(issue_path) }

  let(:page_cls) { NewspaperWorks::Ingest::UUArticleSegmented::PageIngest }

  let(:article_cls) {
    NewspaperWorks::Ingest::UUArticleSegmented::ArticleIngest
  }

  describe "construction and composition" do
    it "constructs adapter given path" do
      expect(issue.path).to eq issue_path
      expect(issue.doc).to be_a Nokogiri::XML::Document
    end

    it "provides date metadata for issue" do
      expect(issue.publication_date).to eq '1850-06-15'
    end
  end

  describe "enumeration of pages and articles" do
    it "acts like a hash of page path keys, page values" do
      expect(issue.keys).to include page_path
      expect(issue.size).to eq 8
      expect(issue.size).to eq issue.keys.size
      # get value either by [] or by info method:
      page = issue.info(page_path)
      expect(page).to be_a page_cls
      # [] == #info, no duplicate construction of child pages (via memoization):
      page_again = issue[page_path]
      expect(page_again).to be page
    end

    it "provides accessor to list of articles" do
      articles = issue.articles
      expect(articles.size).to eq 18
      article = articles[0]
      expect(article).to be_a article_cls
    end
  end
end
