require_relative '../exceptions/translation_failed_exception'

module Rubyvernac
  module CloudProvider

    class StubbedTranslatorApi

      def initialize(stubbed_translations: 'lib/rubyvernac/stubs')
        @stubbed_translations = stubbed_translations
      end

      def translate(word, _lang_code)
        raise Rubyvernac::TranslationFailedException.new(word) if !translation_mappings.key?(word)
        translation_mappings[word]
      end

      private

        def translation_mappings
          @translation_mappings ||= build_translation_mappings
        end

        def build_translation_mappings
          mappings = {}
          Dir.children(@stubbed_translations).each do |file|
            next if file == 'keywords.yml'
            stub = YAML.load_file("#{@stubbed_translations}/#{file}")

            klass = file.split('.')[0]
            stub[klass].keys.each do |key|
              next if key == 'cname'
              mappings.merge!(stub[klass][key])
            end
          end

          keywords_stub = YAML.load_file("#{@stubbed_translations}/keywords.yml")
          mappings.merge!(keywords_stub)

          stringified_mappings = {}
          mappings.each do |key, val|
            stringified_mappings[key.to_s] = val
          end

          stringified_mappings
        end

    end

  end
end
