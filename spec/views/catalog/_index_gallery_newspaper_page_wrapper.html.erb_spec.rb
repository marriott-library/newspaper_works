# frozen_string_literal: true
require 'spec_helper'
RSpec.describe 'catalog/_index_gallery_newspaper_page_wrapper.html.erb', type: :view do
  let(:query) { 'suffrage' }
  let(:document) { build(:newspaper_page_solr_document) }
  let(:current_search_session) { Search.new(query_params: { q: query }) }

  let(:page) do
    render 'catalog/index_gallery_newspaper_page_wrapper',
           document: document,
           current_search_session: current_search_session,
           document_counter: 0
  end

  before do
    allow(document).to receive(:has_highlight_field?).and_return(false)
    # we need without_partial_double_verification or we get error:
    # View doesn't implement #current_search_session
    without_partial_double_verification do
      allow(view).to receive(:current_search_session).and_return(current_search_session)
    end
  end

  it 'renders the thumbnail' do
    expect(page).to have_selector("img[src='#{document[:thumbnail_path_ss]}']")
  end

  it 'renders links with the IIIF search anchor' do
    expect(page).to have_link(document[:title_tesim].first,
                              href: "/concern/newspaper_pages/#{document[:id]}#?h=#{query}")
  end

  it 'has data attributes for thumbnail highlighting' do
    expect(page).to have_selector("div[data-fileset='#{document[:file_set_ids_ssim].first}']")
    expect(page).to have_selector("div[data-query='#{query}']")
  end
end
