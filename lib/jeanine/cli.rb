require 'fileutils'

module Jeanine
  class CLI
    def initialize(args)
      @args = args
    end

    def execute
      if @args[0] == 'new'
        command_new!
      else
        $stdout.puts "I don't know how to `#{@args[0]}`. Maybe you meant `new`?"
      end
    end

    def command_new!
      FileUtils.mkdir("#{@args[1]}") unless Dir.exists?("#{@args[1]}")
      FileUtils.mkdir("#{@args[1]}/config") unless Dir.exists?("#{@args[1]}/config")
      relative_dir = "lib/jeanine/generator/new"
      Dir.glob("lib/jeanine/generator/new/**/*.*").each do |file|
        new_dir = file.gsub(relative_dir, "#{@args[1]}")[0...-3]
        FileUtils.copy_file(file, new_dir)
      end
      relative_dir = "lib/jeanine/generator/new/config"
      Dir.glob("lib/jeanine/generator/new/config/**/*.*").each do |file|
        new_dir = file.gsub(relative_dir, "#{@args[1]}/config")[0...-3]
        FileUtils.copy_file(file, new_dir)
      end
    end
  end
end
