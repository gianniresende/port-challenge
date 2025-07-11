module Api
  module V1
    class ApplicationService
      Result = Struct.new(:success, :user, :errors, keyword_init: true)
      def self.call(**args, &block)
        new(**args, &block).call
      end
    end
  end
end