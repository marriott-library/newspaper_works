# frozen_string_literal: true
# NewspaperTitle ancestor data
module NewspaperWorks
  # shared NewspaperTitle info for multiple newspaper models
  module TitleInfoPresenter
    def publication_id
      solr_document['publication_id_ssi']
    end

    def publication_title
      solr_document['publication_title_ssi']
    end
  end
end
