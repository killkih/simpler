module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        matched_path = path.match(regexp_path(@path))

        if @method == method && matched_path
          @params = matched_path.named_captures
          true
        else
          false
        end
      end

      private

      def regexp_path(path)
        Regexp.new("\\A#{path.gsub(/(:\w+)/, '(?<\1>\w+)').delete(':')}\\Z")
      end
    end
  end
end
