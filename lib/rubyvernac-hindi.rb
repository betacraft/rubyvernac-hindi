require 'rubyvernac/hindi'
require 'yaml'
require 'pry'

spec = Gem::Specification.find_by_name("rubyvernac-hindi")
gem_root = spec.gem_dir
gem_lib = gem_root + "/lib"
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
      Object.class_eval(class_name).singleton_class.
        send(:alias_method, v.to_sym, k.to_sym) unless v.chop.length.zero?
    rescue

    end
  end

  content.first.last['cprmethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      Object.class_eval(class_name).singleton_class.
        send(:alias_method, v.to_sym, k.to_sym) unless v.chop.length.zero?
    rescue

    end


  end

  # instance methods -
  content.first.last['ipumethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      Object.class_eval(class_name).send(:alias_method, v.to_sym,k.to_sym) unless
                                                    v.chop.length.zero?
    rescue

    end
  end if content.first.last['ipumethods']

  # instance methods -
  content.first.last['iprmethods'].each do |k, v|
    #puts "synching -- #{k} to #{v}"
    begin
      if k.to_sym.in? [:respond_to_missing?, :method_missing]
        next
      end
      Object.class_eval(class_name).send(:alias_method, v.to_sym,k.to_sym) unless
                                                    v.chop.length.zero?
    rescue Exception => e

    end

  end if content.first.last['iprmethods']

end
