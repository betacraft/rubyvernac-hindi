class LanguageNotAvailableException < StandardError
  def message
    "Language not found"
  end
end
