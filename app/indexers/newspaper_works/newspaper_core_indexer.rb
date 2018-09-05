# Core indexer for newspaper work types
module NewspaperWorks
  class NewspaperCoreIndexer < Hyrax::WorkIndexer
    # This indexes the default metadata. You can remove it if you want to
    # provide your own metadata and indexing.
    include Hyrax::IndexesBasicMetadata

    # Fetch remote labels for based_near. You can remove this if you don't want
    # this behavior
    # include Hyrax::IndexesLinkedMetadata

    # Uncomment this block if you want to add custom indexing behavior:
    # def generate_solr_document
    #  super.tap do |solr_doc|
    #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
    #  end
    # end

    def generate_solr_document
      super.tap do |solr_doc|
        if defined? object.place_of_publication_city
          solr_doc['place_of_publication_city_ssim'] = object.place_of_publication_city.to_s
          solr_doc['place_of_publication_tesim'] = object.place_of_publication_city.to_s
        end
        if defined? object.place_of_publication_state
          solr_doc['place_of_publication_state_ssim'] = object.place_of_publication_state.to_s
          if solr_doc.key?("place_of_publication_tesim")
            solr_doc['place_of_publication_tesim'] = object.place_of_publication_state.to_s
          else
            solr_doc['place_of_publication_tesim'] << ", #{object.place_of_publication_state}"
          end
        end
        if defined? object.place_of_publication_country
          solr_doc['place_of_publication_country_ssim'] = object.place_of_publication_country.to_s
          if solr_doc.key?("place_of_publication_tesim")
            solr_doc['place_of_publication_tesim'] = object.place_of_publication_country.to_s
          else
            solr_doc['place_of_publication_tesim'] << ", #{object.place_of_publication_country}"
          end
        end
        if defined? object.place_of_publication_latitude && defined? object.place_of_publication_longitude
          solr_doc['place_of_publication_llsim'] = "#{object.place_of_publication_latitude}, "\
                                                   "#{object.place_of_publication_longitude}"
        end
        if defined? object.publication_date_start
          case object.publication_date_start
          when /\A\d{4}\z/
            solr_doc['publication_date_start_dtsim'] = "#{object.publication_date_start}-01-01T00:00:00Z"
          when /\A\d{4}-\d{2}\z/
            solr_doc['publication_date_start_dtsim'] = "#{object.publication_date_start}-01T00:00:00Z"
          end
        end
        if defined? object.publication_date_end
          case object.publication_date_end
          when /\A\d{4}\z/
            solr_doc['publication_date_end_dtsim'] = "#{object.publication_date_end}-12-31T23:59:59Z"
          when /\A\d{4}-\d{2}\z/
            date_split = object.publication_date_end.split('-')
            end_day = Date.new(date_split[0].to_i, date_split[1].to_i, -1).strftime("%d")
            solr_doc['publication_date_end_dtsim'] = "#{object.publication_date_end}-#{end_day}T23:59:59Z"
          end
        end
      end
    end
  end
end
