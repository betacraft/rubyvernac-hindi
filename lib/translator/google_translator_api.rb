require "google/cloud/translate/v3"
require 'dotenv/load'

module Translator
  class GoogleTranslatorApi
    @instance_mutex = Mutex.new
    private_class_method :new

    def self.instance
      return @instance if @instance

      @instance_mutex.synchronize do
        @instance ||= new
      end

      @instance
    end

    def initialize
      @client ||= ::Google::Cloud::Translate::V3::TranslationService::Client.new do |config|
        config.credentials = ENV["KEYFILE_PATH"]
      end
    end

    def translate(word, target_language_code)
      begin
        response = make_translate_text_request(word, target_language_code)

        translated_word = response.translations.first&.translated_text || ""
      rescue Exception => e
        puts e.message
        translated_word = ''
      end

      #replace spaces -
      translated_word = translated_word.gsub(/ |\./, '_')

      # # return none if it's only latin -
      # !!translated_word.match(/^[a-zA-Z0-9_\-+? ]*$/) ?
      #   '' :
      #   translated_word

      translated_word
    end

    private
      def make_translate_text_request(word, target_language_code)
        request = ::Google::Cloud::Translate::V3::TranslateTextRequest.new(
          contents: ["#{word}"],
          source_language_code: :en,
          target_language_code: target_language_code,
          parent: ENV["GOOGLE_PROJECT_ID"]
        )
        response = @client.translate_text(request)

        response
      end

  end
end
