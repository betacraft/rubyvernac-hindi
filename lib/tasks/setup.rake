require 'yaml'
require 'google_translate'

namespace :setup do 

  desc 'Task to create yml file with all classes and method names'
  task :all do
    puts ObjectSpace.each_object(Class).map(&:name)
  end

  desc 'Task to add yml file with one class and method names'
  task :for_class, [:class_name] do |t, args|
    
    class_name = eval(args[:class_name])
    begin
      content = YAML::load_file(File.expand_path"lib/translations/#{class_name.name.downcase}.yml")
    rescue Errno::ENOENT
      content = Hash.new
    end

    # place to keep class's name - 
    content[class_name.name.downcase] = content[class_name.name.downcase] ||
      Hash.new
    content[class_name.name.downcase]['cname'] = translate(class_name)

    # class methods
    class_name.public_methods.sort.each do |method_name|
      content[class_name.name.downcase]['cpumethods'] = content[class_name.name.downcase]['cpumethods'] ||
        Hash.new

      content[class_name.name.downcase]['cpumethods'][method_name.to_s] = 
        translate(method_name.to_s)
    end

    # class methods
    class_name.private_methods.sort.each do |method_name|
      content[class_name.name.downcase]['cprmethods'] = content[class_name.name.downcase]['cprmethods'] ||
        Hash.new

      content[class_name.name.downcase]['cprmethods'][method_name.to_s] = 
        translate(method_name.to_s)
    end

    # instance methods
    class_name.instance_methods.sort.each do |method_name|
      content[class_name.name.downcase]['ipumethods'] = content[class_name.name.downcase]['ipumethods'] ||
        Hash.new

      content[class_name.name.downcase]['ipumethods'][method_name.to_s] =
        translate(method_name.to_s)
    end

    # instance methods
    class_name.private_instance_methods.sort.each do |method_name|
      content[class_name.name.downcase]['iprmethods'] = content[class_name.name.downcase]['iprmethods'] ||
        Hash.new

      content[class_name.name.downcase]['iprmethods'][method_name.to_s] = 
        translate(method_name.to_s)
    end

    File.open(File.expand_path("lib/translations/#{class_name.name.downcase}.yml"), 'w+') do |f|
      f.write( content.to_yaml )
    end
    
  end

end

def translate(word)
  begin
    str = GoogleTranslate.new.translate('en', 'hi', word).flatten.first
  rescue Exception => e
    puts e.message
    str = ''
  end

  # replace spaces - 
  str = str.gsub(/ |\./, '_')

  # return none if it's only latin - 
  !!str.match(/^[a-zA-Z0-9_\-+? ]*$/) ?
    '' :
    str
end
