require 'active_fedora'
require 'hyrax'

module NewspaperWorks
  # module constants:
  GEM_PATH = Gem::Specification.find_by_name("newspaper_works").gem_dir

  # Engine Class
  class Engine < ::Rails::Engine
    isolate_namespace NewspaperWorks

    config.to_prepare do
      # Register actor to handle any NewspaperWorks upload behaviors before
      #   CreateWithFilesActor gets to them:
      Hyrax::CurationConcern.actor_factory.insert_before Hyrax::Actors::CreateWithFilesActor, Hyrax::Actors::NewspaperWorksUploadActor
    end
  end
end
