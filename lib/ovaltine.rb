
require 'ovaltine/storyboard'
require 'ovaltine/objc/storyboard_formatter'
require 'ovaltine/objc/storyboard_templates'
require 'ovaltine/version'
require 'ovaltine/xcode_project'
require 'ovaltine/xcode_project/pbxobject'
require 'ovaltine/xcode_project/pbxgroup'
require 'ovaltine/xcode_project/pbxfilereference'
require 'ovaltine/xcode_project/ext/stdlib'

module Ovaltine

  def self.create_constant_files(path, options)
    files = Dir.glob("#{path}/**/*.storyboard")
    groups = files.group_by {|f| File.basename(f).sub('.storyboard','')}
    formatters = groups.map do |name, paths|
      storyboard = Storyboard.new(name, paths)
      StoryboardFormatter.new(storyboard, options[:prefix], (options[:output_directory] || path))
    end
    generated_paths = formatters.map(&:output_paths).flatten
    if existing_path = generated_paths.detect {|p| File.exist?(p)} and !options[:auto_replace]
      return unless prompt("Some generated files already exist. Overwrite? (Y/n)", 'y')
    end

    paths = write_files(formatters)

    if project_filepath = options[:project] || Dir.glob("#{File.dirname(path)}/**/*.xcodeproj").first
      return unless options[:auto_add] or prompt("[Experimental] Add files to project? (y/N)", 'n')
      project = XcodeProject.new(project_filepath)
      paths.sort.each {|p| project.add_file_ref(p)}
      project.save
      puts "#{File.basename(project_filepath)} updated"
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
    files
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