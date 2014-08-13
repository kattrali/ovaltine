
module Ovaltine
  class Storyboard
    attr_reader :name, :filepaths, :cell_reuse_identifiers,
                :view_controller_identifiers, :segue_identifiers

    def initialize name, filepaths
      @name, @filepaths = name, filepaths
      @cell_reuse_identifiers = []
      @segue_identifiers = []
      @view_controller_identifiers = []
      filepaths.each {|f| parse(File.expand_path(f))}
    end

    def parse path
      load_dependencies
      document = REXML::Document.new(File.new(path))
      document.get_elements('//').each do |node|
        parse_identifiers(node)
      end
    end

    private

    def load_dependencies
      unless @@loaded ||= false
        require 'fileutils'
        require 'pathname'
        require 'rexml/document'
        @@loaded = true
      end
    end

    def parse_identifiers node
      case node.name
      when 'segue'
        if identifier = node.attributes["identifier"]
          segue_identifiers << identifier
        end
      when /viewcontroller/i, 'navigationController'
        if identifier = node.attributes["storyboardIdentifier"]
          view_controller_identifiers << identifier
        end
      when /cell/i
        if identifier = node.attributes["reuseIdentifier"]
          cell_reuse_identifiers << identifier
        end
      end
    end
  end
end
