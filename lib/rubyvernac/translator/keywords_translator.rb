require 'dotenv/load'
require 'yaml'

require_relative '../exceptions/translation_failed_exception'
require_relative '../cloud_provider/translator_api'
require_relative '../cloud_provider/stubbed_translator_api'

module Rubyvernac

  module Translator
    class KeywordsTranslator

      def initialize(lang_code: , translations_path:, filename:)
        @lang_code = lang_code
        if ENV['STUB_CLOUD_APIS'] == 'true'
          @translator_api = Rubyvernac::CloudProvider::StubbedTranslatorApi.new
        else
          @translator_api = Rubyvernac::CloudProvider::TranslatorApi.new
        end

        @keywords_file_path = "#{translations_path}/#{filename}"
      end

      def generate_translations
        content = YAML.load_file(@keywords_file_path)
        translated_content = {}

        content.each do |key, val|
          begin
            translated_content[key] = @translator_api.translate(val.to_s, @lang_code)
          rescue TranslationFailedException => e
            puts e.message
          end
        end

        write_content_to_file(translated_content.to_yaml)
      end

      private

        def write_content_to_file(content)
          File.open(@keywords_file_path, 'w') do |f|
            f.write(content)
          end
        end

    end
  end

end
