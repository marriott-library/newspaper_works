# Generated via
#  `rails generate hyrax:work NewspaperArticle`
module Hyrax
  class NewspaperArticlePresenter < Hyrax::WorkShowPresenter
    include NewspaperWorks::IiifSearchPresenterBehavior
  end
end
