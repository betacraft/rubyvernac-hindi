module Rubyvernac

  class TranslationFailedException < StandardError

    def initialize(text)
      @text = text
    end

    def message
      "Translation failed for #{@text}"
    end
  end

end
