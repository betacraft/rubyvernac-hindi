require 'yaml'

require_relative '../exceptions/translation_failed_exception'
require_relative '../cloud_provider/translator_api'
require_relative '../cloud_provider/stubbed_translator_api'

module Rubyvernac
  module Translator

    class LanguageBasedTranslator

      def initialize(lang_code: , translations_path:, filename:)
        @lang_code = lang_code
        @translations_path = translations_path + '/classes'
        @filename = filename

        if ENV['STUB_CLOUD_APIS'] == 'true'
          @translator_api = CloudProvider::StubbedTranslatorApi.new
        else
          @translator_api = CloudProvider::TranslatorApi.new
        end
      end

      def generate_translations
        content = YAML.load_file(class_file_path)

        base_class_name = @filename.split('.')[0]
        method_types = content[base_class_name].keys
        method_types.each do |method_type|
          next if method_type == "cname"

          method_names = content[base_class_name][method_type].keys
          method_names.each do |method_name|
            content[base_class_name][method_type][method_name] = translate_text(method_name)
          end
        end

        content[base_class_name]['cname'] = translate_text(content[base_class_name]['cname'])
        write_content_to_file(content.to_yaml)
      end

      private
        def class_file_path
          "#{@translations_path}/#{@filename}"
        end

        def write_content_to_file(content)
          File.open(class_file_path, 'w') do |f|
            f.write(content)
          end
        end

        def translate_text(text)
          @translator_api.translate(text, @lang_code)
        rescue TranslationFailedException => e
          puts e.message
          return ''
        end

    end

  end
end
