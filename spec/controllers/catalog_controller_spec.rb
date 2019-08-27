require 'spec_helper'

# specs to test that install generators have correctly modified CatalogController
RSpec.describe CatalogController do
  describe 'NewspaperWorks::InstallGenerator#add_index_fields_to_catalog_controller' do
    subject { described_class.blacklight_config.index_fields }

    it 'has NewspaperWorks index fields' do
      expect(subject['publication_title_ssi']).not_to be_falsey
      expect(subject['place_of_publication_label_tesim']).not_to be_falsey
      expect(subject['publication_date_dtsi'].class).to eq(Blacklight::Configuration::IndexField)
    end
  end

  describe 'NewspaperWorks::InstallGenerator#add_facets_to_catalog_controller' do
    subject { described_class.blacklight_config.facet_fields }

    it 'has NewspaperWorks facet fields' do
      expect(subject['place_of_publication_city_sim']).not_to be_falsey
      expect(subject['publication_title_ssi'].class).to eq(Blacklight::Configuration::FacetField)
      expect(subject['genre_sim'].label).to eq('Article type')
    end

    it 'has definitions for non-displaying facet fields' do
      expect(subject['place_of_publication_label_sim']).not_to be_falsey
      expect(subject['issn_sim']).not_to be_falsey
      expect(subject['lccn_sim']).not_to be_falsey
      expect(subject['oclcnum_sim']).not_to be_falsey
      expect(subject['held_by_sim']).not_to be_falsey
      expect(subject['author_sim']).not_to be_falsey
      expect(subject['photographer_sim']).not_to be_falsey
      expect(subject['geographic_coverage_sim']).not_to be_falsey
      expect(subject['preceded_by_sim']).not_to be_falsey
      expect(subject['succeeded_by_sim']).not_to be_falsey
    end
  end

  describe 'NewspaperWorks::InstallGenerator#add_pubdate_sort_to_catalog_controller' do
    subject { described_class.blacklight_config.sort_fields }

    it 'has NewspaperWorks sort fields' do
      expect(subject['publication_date_dtsi asc'].class).to eq Blacklight::Configuration::SortField
      expect(subject['publication_date_dtsi desc'].field).to eq 'publication_date_dtsi desc'
    end
  end

  describe 'NewspaperWorks::BlacklightAdvancedSearchGenerator' do
    subject { described_class.blacklight_config }

    describe '#update_search_builder' do
      it 'sets the default SearchBuilder' do
        expect(subject.search_builder_class).to eq CustomSearchBuilder
      end
    end

    describe '#add_newspapers_advanced_config' do
      it 'adds the advanced_search[:newspapers_search] config' do
        expect(subject.advanced_search[:newspapers_search]).not_to be_falsey
        expect(subject.advanced_search[:newspapers_search][:form_solr_parameters]['facet.field']).not_to be_blank
      end
    end
  end
end
