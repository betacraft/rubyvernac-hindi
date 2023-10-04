require "fileutils"

require_relative 'file_based_translator'
require_relative 'language_based_translator'
require_relative 'language_codes'

module Translator
  class Main

    def initialize(language: nil)
      @language = language
      translations_path = Dir.pwd + "/lib/translations"

      lang_code = LanguageCodes.new.find_code(language)
      @language_based_translator = LanguageBasedTranslator.new(lang_code: lang_code, translations_path: translations_path)
      @file_based_translator = FileBasedTranslator.new(
        lang_code: lang_code,
        translations_path: translations_path,
        input_file: "keywords.txt",
        output_file: "keywords.txt"
      )
    end

    def generate_translations
      return if @language.nil?

      print "\n\nGetting translations\n"
      print "== Please wait this will take some time ==\n"
      thread_1 = Thread.new do
        @file_based_translator.process_file
        FileUtils.touch(Dir.pwd + "/bin/.file_based_translations_completed")
      end
      thread_2 = Thread.new do
        @language_based_translator.generate_translations
        FileUtils.touch(Dir.pwd + "/bin/.language_based_translations_completed")
      end

      display_spinner([ thread_1, thread_2 ])

      thread_1.join
      thread_2.join
    end

    private

      def display_spinner(threads)
        spinner = Enumerator.new do |e|
            loop do
              e.yield '|'
              e.yield '/'
              e.yield '-'
              e.yield '\\'
            end
          end
        while threads.any? { |thread| thread.alive? }
          printf("\r%s", spinner.next)
          sleep(0.1)
        end
        printf("%s", "")
      end

  end
end
