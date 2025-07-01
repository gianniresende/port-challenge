module Api
  module V1
    class ApplicationService
      def self.call(**kwargs, &block)
        new(**kwargs, &block).call
      end
    end
  end
end