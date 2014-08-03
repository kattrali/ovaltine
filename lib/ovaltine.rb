
require 'ovaltine/storyboard'
require 'ovaltine/objc/storyboard_formatter'
require 'ovaltine/objc/storyboard_templates'
require 'ovaltine/version'

module Ovaltine

  def self.create_constant_files(path, options)
    files = Dir.glob("#{path}/**/*.storyboard")
    groups = files.group_by {|f| File.basename(f).sub('.storyboard','')}
    formatters = groups.map do |name, paths|
      storyboard = Storyboard.new(name, paths)
      StoryboardFormatter.new(storyboard, options[:prefix], options[:output_directory])
    end
    generated_paths = formatters.map(&:output_paths).flatten
    if path = generated_paths.detect {|p| File.exist?(p)} and !options[:auto_replace]
      if prompt("Some generated files already exist. Overwrite? (Y/n)", 'y')
        write_files(formatters)
      end
    else
      write_files(formatters)
    end
  end

  private

  def self.write_files formatters
    files = []
    formatters.each do |formatter|
      formatter.write
      files += formatter.output_paths
    end
    files.each do |path|
      puts "  * #{File.basename(path)}"
    end
    puts "\n#{files.size} files generated"
  end

  def self.prompt title, default_answer
    puts title
    answer = STDIN.gets.chomp
    if answer.length == 0
      default_answer == 'y'
    elsif !['y','n'].include?(answer.downcase)
      false
    else
      answer.downcase == 'y'
    end
  end
end