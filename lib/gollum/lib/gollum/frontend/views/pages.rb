module Precious
  module Views
    class Pages < Layout
      attr_reader :results, :ref

      def title
        "All pages in #{@ref}"
      end

      def has_results
        !@results.empty?
      end

      def no_results
        @results.empty?
      end

      def mount_point
        @mount_point
      end
    end
  end
end
