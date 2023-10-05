require 'yaml'

class LanguageAliasLoader

  def initialize(parser:)
    @parser = parser
  end

  def create_aliases(translations_path)
    Dir.glob(translations_path + '/*.yml').each do |filepath|
      content = YAML.load_file(File.expand_path"#{filepath}")
      class_name = content.keys[0].capitalize

      # class name -
      # class_trans = content[content.keys.first]['cname']
      # Object.class_eval(" #{class_trans} = #{class_name} ") unless class_trans.length.zero?

      # class methods -
      content.first.last['cpumethods'].each do |k, v|
        @parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
      end

      content.first.last['cprmethods'].each do |k, v|
        @parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
      end

      # instance methods -
      content.first.last['ipumethods'].each do |k, v|
        @parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
      end if content.first.last['ipumethods']

      # instance methods -
      content.first.last['iprmethods'].each do |k, v|
        next if [:respond_to_missing?, :method_missing].include?(k.to_sym)
        @parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
      end if content.first.last['iprmethods']

    end
  end
end
