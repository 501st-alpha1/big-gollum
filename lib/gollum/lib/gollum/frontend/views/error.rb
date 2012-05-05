module Precious
  module Views
    class Error < Layout
      attr_reader :message

      def mount_point
        @mount_point
      end
    end
  end
end
