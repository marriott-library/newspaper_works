# Generated via
#  `rails generate hyrax:work NewspaperTitle`
module Hyrax
  # Newspaper Title Form Class
  class NewspaperTitleForm < ::NewspaperWorks::NewspaperCoreFormData
    self.model_class = ::NewspaperTitle
    self.terms += [:alt_title, :edition_name, :frequency, :preceded_by,
                   :succeeded_by, :publication_date_start,
                   :publication_date_end]
    self.terms -= [:creator, :contributor, :description, :source, :subject]
  end
end
