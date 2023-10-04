require_relative 'google_translator_api'
require_relative 'stubbed_translator_api'

module Translator
  class FileBasedTranslator

    def initialize(lang_code: , translations_path:, input_file:, output_file:)
      @lang_code = lang_code
      # @translator_api = GoogleTranslatorApi.instance
      @translator_api = StubbedTranslatorApi.new

      @input_file = File.open("#{translations_path}/#{input_file}")
      @output_file = File.open("#{translations_path}/#{output_file}")
    end

    def process_file
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

          translated_word = @translator_api.translate(line, @lang_code) rescue ""
          next if translated_word.nil? || translated_word.empty?

          translated_keywords << "#{translated_word} #{line}"
        end

        # hard coding missing keywords
        translated_keywords << "#{@translator_api.translate("else if", @lang_code)} elseif"

        translated_keywords
      end

      def write_to_output_file(translated_keywords)
        content = translated_keywords.join("\n")

        File.open(@output_file, "w") {|f| f.write(content) }
      end

  end
end
