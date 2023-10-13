require_relative "../rubyvernac/translator/main"

namespace :setup do

  desc "Fetch translations of keywords"
  task :fetch_translations, [:filename] do |t, args|
    if (args[:filename] || '').empty?
      puts "Please provide a file to be translated => rake setup:fetch_translations[example.yml]"
    else
      translator = Rubyvernac::Translator::Main.new(language: "hindi", filename: args[:filename])
      translator.generate_translations
    end
  end

end
