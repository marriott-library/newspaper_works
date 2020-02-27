# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work NewspaperArticle`
module Hyrax
  class NewspaperArticleForm < ::NewspaperWorks::NewspaperCoreFormData
    self.model_class = ::NewspaperArticle
    self.terms += [:alternative_title, :genre, :author, :photographer,
                   :publication_date, :volume, :edition_number, :edition_name,
                   :issue_number, :geographic_coverage, :extent, :page_number,
                   :section]
  end
end
