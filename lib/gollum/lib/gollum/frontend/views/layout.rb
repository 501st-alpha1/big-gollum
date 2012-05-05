require 'cgi'

module Precious
  module Views
    class Layout < Mustache
      include Rack::Utils
      include ViewHelpers
      alias_method :h, :escape_html

      attr_reader :name

      def escaped_name
        CGI.escape(@name)
      end

      def title
        "Home"
      end

      def mount_point
        @mount_point
      end
    end
  end
end
