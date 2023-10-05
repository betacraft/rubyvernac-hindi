require "google/cloud/translate/v3"
require 'dotenv/load'

require_relative '../exceptions/translation_failed_exception'

module Translator
  class StubbedTranslatorApi

    def translate(word, _lang_code)
      raise TranslationFailedException.new(word) if !translation_mappings.key?(word)
      translation_mappings[word]
    end

    def translation_mappings
      @translation_mappings ||= build_translation_mappings
    end

    def build_translation_mappings
      mappings = {}
      Dir.children('lib/stubs').each do |file|
        next if file == 'keywords.yml'
        stub = YAML.load_file("lib/stubs/#{file}")

        klass = file.split('.')[0]
        stub[klass].keys.each do |key|
          next if key == 'cname'
          mappings.merge!(stub[klass][key])
        end
      end

      keywords_stub = YAML.load_file("lib/stubs/keywords.yml")
      mappings.merge!(keywords_stub)

      stringified_mappings = {}
      mappings.each do |key, val|
        stringified_mappings[key.to_s] = val
      end

      stringified_mappings
    end

  end
end
