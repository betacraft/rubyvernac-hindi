require 'rubyvernac/hindi'
require 'ruby-vernac-parser'
require 'yaml'
require 'pry'


spec = Gem::Specification.find_by_name("rubyvernac-hindi")
gem_root = spec.gem_dir
gem_lib = gem_root + "/lib"

parser = RubyVernacParser.new

# create aliases
#puts "Creating aliases"
Dir.glob(gem_lib+'/translations/*.yml').each do |filepath|
  content = YAML::load_file(File.expand_path"#{filepath}")
  # puts "working on file #{filepath}"
  begin
    class_name = content.keys.first.capitalize
    rescue Exception => e
      puts "exception in getting classname #{e}"
      return
  end


  # class name -
  # class_trans = content[content.keys.first]['cname']
  # Object.class_eval(" #{class_trans} = #{class_name} ") unless class_trans.length.zero?

  # class methods -
  content.first.last['cpumethods'].each do |k, v|
    #puts "syncing -- #{k} to #{v}"
    begin
      parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
    rescue Exception => e

    end
  end

  content.first.last['cprmethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      parser.alias_class_method(class_name, k, v) unless v.chop.length.zero?
    rescue Exception => e

    end


  end

  # instance methods -
  content.first.last['ipumethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
    rescue Exception => e

    end
  end if content.first.last['ipumethods']

  # instance methods -
  content.first.last['iprmethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      next if k.to_sym.in?([:respond_to_missing?, :method_missing])
      parser.alias_instance_method(class_name, k, v) unless v.chop.length.zero?
    rescue Exception => e

    end

  end if content.first.last['iprmethods']

end
