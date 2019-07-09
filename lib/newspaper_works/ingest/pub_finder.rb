require 'newspaper_works/logging'
require 'newspaper_works/ingest'

module NewspaperWorks
  module Ingest
    # mixin for find-or-create of publication, for use by various ingests
    module PubFinder
      include NewspaperWorks::Logging

      COPY_FIELDS = [
        :title,
        :lccn,
        :oclcnum,
        :issn,
        :place_of_publication,
        :language,
        :preceded_by,
        :succeeded_by
      ].freeze

      MULTI_VALUED = [
        :title,
        :language,
        :preceded_by,
        :succeeded_by,
        :place_of_publication
      ].freeze

      # @param lccn [String] Library of Congress Control Number
      #   of Publication
      # @return [NewspaperTitle, NilClass] publication or nil if not found
      def find_publication(lccn)
        NewspaperTitle.where(lccn: lccn).first
      end

      # Copy publication metadata from authority lookup for LCCN
      # @param publication [NewspaperTitle]
      # @param metadata [NewspaperWorks::Ingest::PublicationInfo]
      def copy_publication_metadata(publication, metadata, title = nil)
        COPY_FIELDS.each do |name|
          value = metadata.send(name)
          next if value.nil?
          value = [value] if MULTI_VALUED.include?(name)
          publication.send("#{name}=", value)
        end
        # prefer locally-specified title to looked-up title:
        publication.title = [title] unless title.nil?
      end

      def create_publication(lccn, title = nil, opts = {})
        publication = NewspaperTitle.create
        info = NewspaperWorks::Ingest::PublicationInfo.new(lccn)
        copy_publication_metadata(publication, info, title)
        publication.lccn ||= lccn
        NewspaperWorks::Ingest.assign_administrative_metadata(publication, opts)
        publication.save!
        write_log(
          "Created NewspaperTitle work #{publication.id} for LCCN #{lccn}"
        )
        publication
      end

      def find_or_create_publication_for_issue(issue, lccn, title, opts)
        publication = find_publication(lccn)
        unless publication.nil?
          write_log(
            "Found existing NewspaperTitle #{publication.id}, LCCN #{lccn}"
          )
        end
        publication = create_publication(lccn, title, opts) if publication.nil?
        publication.ordered_members << issue
        publication.save!
        write_log(
          "Linked NewspaperIssue #{issue.id} to "\
          "NewspaperTitle work #{publication.id}"
        )
      end
    end
  end
end
