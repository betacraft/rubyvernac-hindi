require "fileutils"

require_relative 'keywords_translator'
require_relative 'language_based_translator'
require_relative 'language_codes'

module Rubyvernac
  module Translator
    class Main

      def initialize(language:, filename:)
        @language = language
        translations_path = Dir.pwd + "/lib/translations"

        lang_code = Rubyvernac::Translator::LanguageCodes.new.find_code(language)

        if filename == 'keywords.yml'
          @translator = Rubyvernac::Translator::KeywordsTranslator.new(
            lang_code: lang_code,
            translations_path: translations_path,
            filename: filename
          )
        else
          @translator = Rubyvernac::Translator::LanguageBasedTranslator.new(
            lang_code: lang_code,
            translations_path: translations_path,
            filename: filename
          )
        end

      end

      def generate_translations
        return if @language.nil?

        print "\n\nGetting translations\n"
        print "== Please wait this will take some time ==\n"
        @translator.generate_translations
      end

    end
  end
end
