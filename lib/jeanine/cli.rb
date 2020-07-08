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
      $stdout.puts("Creating new app #{@args[1]}")
      FileUtils.mkdir("#{@args[1]}") unless Dir.exists?("#{@args[1]}")
      FileUtils.mkdir("#{@args[1]}/config") unless Dir.exists?("#{@args[1]}/config")
      FileUtils.mkdir("#{@args[1]}/tmp") unless Dir.exists?("#{@args[1]}/tmp")
      FileUtils.mkdir("#{@args[1]}/tmp/pids") unless Dir.exists?("#{@args[1]}/tmp/pids")
      FileUtils.touch("#{@args[1]}/tmp/pids/.keep") unless File.exists?("#{@args[1]}/tmp/pids/.keep")
      relative_dir = "#{__dir__}/generator/new"
      Dir.glob("#{__dir__}/generator/new/**/*.*").each do |file|
        new_dir = file.gsub(relative_dir, "#{@args[1]}")[0...-3]
        FileUtils.copy_file(file, new_dir)
      end
      relative_dir = "#{__dir__}/generator/new/config"
      Dir.glob("#{__dir__}/generator/new/config/**/*.*").each do |file|
        new_dir = file.gsub(relative_dir, "#{@args[1]}/config")[0...-3]
        FileUtils.copy_file(file, new_dir)
      end
      $stdout.puts("Created #{@args[1]}!")
    end
  end
end
