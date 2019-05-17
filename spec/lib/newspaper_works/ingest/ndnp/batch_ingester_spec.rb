require 'spec_helper'
require 'ndnp_shared'

RSpec.describe NewspaperWorks::Ingest::NDNP::BatchIngester do
  include_context "ndnp fixture setup"

  describe "adapter construction" do
    it "loads batch to operate on" do
      adapter = described_class.new(batch1)
      expect(adapter.batch).to be_a NewspaperWorks::Ingest::NDNP::BatchXMLIngest
      expect(adapter.batch.path).to eq adapter.path
    end

    it "finds batch xml, if given path containing batch" do
      parent_path = File.dirname(batch1)
      adapter = described_class.new(parent_path)
      expect(adapter.path).to eq batch1
      expect(adapter.batch.path).to eq adapter.path
    end
  end

  describe "ingests issues" do
    it "calls ingest for all issues in batch" do
      adapter = described_class.new(batch1)
      issue_ingest_call_count = 0
      # rubocop:disable RSpec/AnyInstance (we really need to stub this way)
      allow_any_instance_of(NewspaperWorks::Ingest::NDNP::IssueIngester).to \
        receive(:ingest) { issue_ingest_call_count += 1 }
      # rubocop:enable RSpec/AnyInstance
      adapter.ingest
      expect(issue_ingest_call_count).to eq 4
    end
  end

  describe "command invocation" do
    def construct(args)
      described_class.from_command(
        args,
        'rake newspaper_works:ingest_ndnp --'
      )
    end

    it "creates ingester from command arguments" do
      fake_argv = ['newspaper_works:ingest_ndnp', '--', "--path=#{batch1}"]
      adapter = construct(fake_argv)
      expect(adapter).to be_a described_class
      expect(adapter.path).to eq batch1
    end

    it "exits on file not found for batch" do
      fake_argv = ['newspaper_works:ingest_ndnp', '--', "--path=123/45/5678"]
      begin
        construct(fake_argv)
      rescue SystemExit => e
        expect(e.status).to eq(1)
      end
    end

    it "exits on missing path for batch" do
      fake_argv = ['newspaper_works:ingest_ndnp', '--']
      begin
        construct(fake_argv)
      rescue SystemExit => e
        expect(e.status).to eq(1)
      end
    end

    it "exits on unexpected arguments" do
      fake_argv = ['newspaper_works:ingest_ndnp', '--', '--foo=bar']
      expect { construct(fake_argv) }.to raise_error(
        OptionParser::InvalidOption
      )
    end
  end
end
