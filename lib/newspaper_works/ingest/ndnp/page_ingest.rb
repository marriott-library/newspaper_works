module NewspaperWorks
  module Ingest
    module NDNP
      class PageIngest
        include NewspaperWorks::Ingest::NDNP::NDNPMetsHelper

        attr_accessor :path, :dmdid, :doc

        def initialize(path = nil, dmdid = nil)
          raise ArgumentError('No path provided') if path.nil?
          @path = path
          @dmdid = dmdid
          @doc = nil
          @metadata = nil
          load_doc
        end

        def inspect
          format(
            "<#{self.class}:0x000000000%<oid>x\n" \
              "\tpath: '#{path}',\n" \
              "\tdmdid: '#{dmdid}' ...>",
            oid: object_id << 1
          )
        end

        def files
          page_files.values.map(&method(:normalize_path))
        end

        def metadata
          return @metadata unless @metadata.nil?
          @metadata = NewspaperWorks::Ingest::NDNP::PageMetadata.new(
            path,
            self,
            dmdid
          )
        end

        private

          def load_doc
            @doc = Nokogiri::XML(File.open(path)) if @doc.nil?
          end
      end
    end
  end
end
