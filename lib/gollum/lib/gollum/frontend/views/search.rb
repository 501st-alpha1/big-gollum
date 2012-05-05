module Precious
  module Views
    class Search < Layout
      attr_reader :content, :page, :footer, :results, :query

      def title
        "Search results for " + @query
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
