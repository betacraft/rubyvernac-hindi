require_relative 'gcp/google_translator_api'

require 'forwardable'

module Rubyvernac

  module CloudProvider
    class TranslatorApi
      extend Forwardable

      def_delegator :@cloud_provider, :translate

      def initialize(cloud_provider: Gcp::GoogleTranslatorApi.instance)
        @cloud_provider = cloud_provider
      end

    end
  end

end
