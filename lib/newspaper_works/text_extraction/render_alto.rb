require 'nokogiri'

module NewspaperWorks
  # Module for text extraction (OCR or otherwise)
  module TextExtraction
    class RenderAlto
      def initialize(width, height, scaling = 1.0)
        @height = height
        @width = width
        @scaling = scaling
      end

      def to_alto(words)
        page = alto_page(@width, @height) do |xml|
          words.each do |word|
            xml.String(
              CONTENT: word[:word],
              HEIGHT: scale_point(word[:y_end] - word[:y_start]).to_s,
              WIDTH: scale_point(word[:x_end] - word[:x_start]).to_s,
              HPOS: scale_point(word[:x_start]).to_s,
              VPOS: scale_point(word[:y_start]).to_s
            ) { xml.text '' }
          end
        end
        page.to_xml
      end

      private

        # given block to manage word generation, wrap with page/block/line
        def alto_page(pxwidth, pxheight, &block)
          builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
            xml.alto(xmlns: 'http://www.loc.gov/standards/alto/ns-v2#') do
              xml.Description do
                xml.MeasurementUnit 'pixel'
              end
              alto_layout(xml, pxwidth, pxheight, &block)
            end
          end
          builder
        end

        def scale_point(value)
          # note: presuming non-fractional, even though ALTO 2.1
          #   specifies coordinates are xsd:float, not xsd:int,
          #   simplify to integer value for output:
          (value * @scaling).to_i
        end

        # return layout for page
        def alto_layout(xml, pxwidth, pxheight, &block)
          xml.Layout do
            xml.Page(ID: 'ID1',
                     PHYSICAL_IMG_NR: '1',
                     HEIGHT: pxwidth.to_i,
                     WIDTH: pxheight.to_i) do
              xml.PrintSpace(HEIGHT: pxheight.to_i,
                             WIDTH: pxwidth.to_i,
                             HPOS: '0',
                             VPOS: '0') do
                alto_blockline(xml, pxwidth, pxheight, &block)
              end
            end
          end
        end

        # make block line and call word-block
        def alto_blockline(xml, pxwidth, pxheight)
          xml.TextBlock(ID: 'ID1a',
                        HEIGHT: pxheight.to_i,
                        WIDTH: pxwidth.to_i,
                        HPOS: '0',
                        VPOS: '0') do
            xml.TextLine(HEIGHT: pxheight.to_i,
                         WIDTH: pxwidth.to_i,
                         HPOS: '0',
                         VPOS: '0') do
              yield(xml)
            end
          end
        end
    end
  end
end
