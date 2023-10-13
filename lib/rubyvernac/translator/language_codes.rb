require 'yaml'

module Rubyvernac
  module Translator

    class LanguageCodes

      def initialize(config_path: "lib/available_languages.yml")
        @config_path = config_path
      end

      def find_code(language)
        return available_languages[language]
      end

      private
        def available_languages
          @_available_languages ||= YAML::load_file(@config_path)
          @_available_languages
        end

    end

  end
end
