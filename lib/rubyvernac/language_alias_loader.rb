require 'yaml'
require 'pry'

class LanguageAliasLoader

  def initialize(parser:)
    @parser = parser
  end

  def create_aliases(translations_path)
    # create aliases
    #puts "Creating aliases"
    Dir.glob(translations_path + '/*.yml').each do |filepath|
      content = YAML.load_file(File.expand_path"#{filepath}")
      # puts "working on file #{filepath}"
      begin
        class_name = content.keys[0].capitalize
      rescue StandardError => e
        puts "exception in getting classname #{e.message}"
        return
      end


      # class name -
      # class_trans = content[content.keys.first]['cname']
      # Object.class_eval(" #{class_trans} = #{class_name} ") unless class_trans.length.zero?

      # class methods -
      content.first.last['cpumethods'].each do |k, v|
        #puts "syncing -- #{k} to #{v}"
        begin
          @parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
        rescue StandardError => e

        end
      end

      content.first.last['cprmethods'].each do |k, v|
        #puts "synching -- #{k} to #{v}"
        begin
          @parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
        rescue StandardError => e

        end


      end

      # instance methods -
      content.first.last['ipumethods'].each do |k, v|
        #puts "synching -- #{k} to #{v}"
        begin
          @parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
        rescue StandardError => e

        end
      end if content.first.last['ipumethods']

      # instance methods -
      content.first.last['iprmethods'].each do |k, v|
        #puts "synching -- #{k} to #{v}"
        begin
          next if k.to_sym.in?([:respond_to_missing?, :method_missing])
          @parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
        rescue StandardError => e

        end

      end if content.first.last['iprmethods']

    end
  end
end
