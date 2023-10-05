require 'dotenv/load'

require_relative '../exceptions/translation_failed_exception'
require_relative 'google_translator_api'
require_relative 'stubbed_translator_api'

module Translator
  class KeywordsTranslator

    def initialize(lang_code: , translations_path:, filename:)
      @lang_code = lang_code
      @translator_api = ENV['STUB_CLOUD_APIS'] == 'true' ? StubbedTranslatorApi.new : GoogleTranslatorApi.instance

      @input_file = File.open("#{translations_path}/#{filename}")
      @output_file = File.open("#{translations_path}/#{filename}")
    end

    def generate_translations
      translated_keywords = translate_input_file
      write_to_output_file(translated_keywords)
    end

    private

      def translate_input_file
        translated_keywords = []
        lines = @input_file.readlines

        lines.each do |line|
          line = line.chomp
          next if line.empty?

          begin
            translated_word = @translator_api.translate(line, @lang_code)
            translated_keywords << "#{translated_word} #{line}"
          rescue TranslationFailedException => e
            puts e.message
          end
        end

        # hard coding missing keywords
        translated_keywords << "#{@translator_api.translate("else if", @lang_code)} elsif" rescue ""

        translated_keywords
      end

      def write_to_output_file(translated_keywords)
        content = translated_keywords.join("\n")

        File.open(@output_file, "w") {|f| f.write(content) }
      end

  end
end
