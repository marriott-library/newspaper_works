module NewspaperWorks
  # Create child page works for issue
  class CreateIssuePagesJob < NewspaperWorks::ApplicationJob
    def perform(work, pdf_paths, user, admin_set_id)
      # we will need depositor set on work, if it is nil
      work.depositor ||= user
      # if we do not have admin_set_id yet, set it on the issue work:
      work.admin_set_id ||= admin_set_id
      # create child pages for each page within each PDF uploaded:
      pdf_paths.each do |path|
        adapter = NewspaperWorks::Ingest::NewspaperIssueIngest.new(work)
        adapter.load(path)
        adapter.create_child_pages
      end
      # re-save pages so that parent and sibling relationships are indexed
      work.pages.each(&:save)
    end
  end
end
