require 'yaml'
require_relative 'google_translator_api'
require_relative 'stubbed_translator_api'

module Translator
  class LanguageBasedTranslator
    CONFIG = {
      classes: ["Array", "Class", "Object", "Integer", "Math"],
      methods: {
        public_methods: 'cpumethods',
        private_methods: 'cprmethods',
        instance_methods: 'ipumethods',
        private_instance_methods: 'iprmethods'
      }
    }.freeze

    def initialize(lang_code: , translations_path:)
      @lang_code = lang_code
      @translations_path = translations_path

      # @translator_api = GoogleTranslatorApi.instance
      @translator_api = StubbedTranslatorApi.new
    end

    def generate_translations
      CONFIG[:classes].each do |klass|
        klass = eval(klass) # Note: Fixnum -> Integer
        content = {}
        class_name = klass.name.downcase

        # place to keep class's name -
        content[class_name] = content[class_name] || {}
        content[class_name]['cname'] = @translator_api.translate(klass.name, @lang_code)

        class_name = klass.name.downcase
        CONFIG[:methods].each do |method, key|
          klass.send(method).sort.each do |method_name|
            content[class_name][key] = content[class_name][key] || {}
            content[class_name][key][method_name.to_s] = @translator_api.translate(method_name.to_s, @lang_code)
          end
        end

        translation_path = "#{@translations_path}/#{class_name}.yml"
        File.open(translation_path, 'w+') do |f|
          f.write( content.to_yaml )
        end
      end
    end

  end
end
