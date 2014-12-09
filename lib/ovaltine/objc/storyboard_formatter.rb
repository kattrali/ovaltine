
module Ovaltine
  class StoryboardFormatter
    attr_reader :storyboard, :classname

    CELL_REUSE_SECTION_TITLE='Cell Reuse Identifiers'
    SEGUE_SECTION_TITLE='Segue Identifiers'
    VIEW_CONTROLLER_SECTION_TITLE='View Controllers'

    def initialize storyboard, prefix, copyright, output_path
      scrubbed_name = storyboard.name.gsub(/\W/,'_')
      @storyboard = storyboard
      @prefix = prefix
      @classname = "#{@prefix}#{scrubbed_name}Storyboard"
      @copyright = copyright
      @header_path = File.join(File.expand_path(output_path), "#{classname}.h")
      @impl_path = File.join(File.expand_path(output_path), "#{classname}.m")
    end

    def output_paths
      [@header_path, @impl_path]
    end

    def write
      File.open(@header_path, 'w') do |file|
        file.puts generate_header
      end
      File.open(@impl_path, 'w') do |file|
        file.puts generate_implementation
      end
    end

    def copyright_text
      if @copyright.length > 0
        "Copyright (c) #{Time.new.year} #{@copyright}. All rights reserved."
      else
        ''
      end
    end

    private

    def generate_header
      StoryboardTemplates::HEADER_TEMPLATE\
        .gsub('{FILENAME}', "#{classname}.h")\
        .gsub('{CLASS_NAME}', classname)\
        .gsub('{REUSE_IDENTIFIERS}', reuse_identifier_definitions)\
        .gsub('{SEGUE_IDENTIFIERS}', segue_identifier_definitions)\
        .gsub('{VIEW_CONTROLLERS}', view_controller_definitions)\
        .gsub('{COPYRIGHT}', copyright_text)
    end

    def generate_implementation
      StoryboardTemplates::IMPLEMENTATION_TEMPLATE\
        .gsub('{FILENAME}', "#{classname}.m")\
        .gsub('{CLASS_NAME}', classname)\
        .gsub('{STATIC_VARIABLES}', static_variables)\
        .gsub('{REUSE_IDENTIFIERS}', reuse_identifier_implementations)\
        .gsub('{SEGUE_IDENTIFIERS}', segue_identifier_implementations)\
        .gsub('{VIEW_CONTROLLERS}', view_controller_implementations)\
        .gsub('{COPYRIGHT}', copyright_text)\
        .gsub('{STORYBOARD}', StoryboardTemplates::STORYBOARD_IMPLEMENTATION_TEMPLATE.gsub('{IDENTIFIER_CONSTANT_NAME}', variable_name(storyboard.name)))
    end

    def static_variables
      identifiers = (storyboard.cell_reuse_identifiers + 
        storyboard.view_controller_identifiers + 
        storyboard.segue_identifiers + [storyboard.name]).sort.uniq
      identifiers.map do |identifier|
        StoryboardTemplates::STATIC_IDENTIFIER_TEMPLATE\
          .gsub('{IDENTIFIER}', identifier)\
          .gsub('{IDENTIFIER_CONSTANT_NAME}', variable_name(identifier))
      end.join("\n")
    end

    def reuse_identifier_definitions
      prepend_title(CELL_REUSE_SECTION_TITLE, storyboard.cell_reuse_identifiers.each_with_index.map do |identifier, index|
        StoryboardTemplates::REUSE_DEFINITION_TEMPLATE.gsub('{IDENTIFIER}', format_reuse_identifier(identifier))
      end.join("\n"))
    end

    def reuse_identifier_implementations
      prepend_title(CELL_REUSE_SECTION_TITLE, storyboard.cell_reuse_identifiers.sort.each_with_index.map do |identifier, index|
        StoryboardTemplates::REUSE_IMPLEMENTATION_TEMPLATE\
          .gsub('{IDENTIFIER}', format_reuse_identifier(identifier))\
          .gsub('{IDENTIFIER_CONSTANT_NAME}', variable_name(identifier))
      end.join("\n"))
    end

    def segue_identifier_definitions
      prepend_title(SEGUE_SECTION_TITLE, storyboard.segue_identifiers.sort.each_with_index.map do |identifier, index|
        StoryboardTemplates::SEGUE_DEFINITION_TEMPLATE.gsub('{IDENTIFIER}', format(identifier, 'identifier', 'SegueIdentifier'))
      end.join("\n"))
    end

    def segue_identifier_implementations
      prepend_title(SEGUE_SECTION_TITLE, storyboard.segue_identifiers.sort.each_with_index.map do |identifier, index|
        StoryboardTemplates::SEGUE_IMPLEMENTATION_TEMPLATE\
          .gsub('{IDENTIFIER}', format_segue_identifier(identifier))\
          .gsub('{IDENTIFIER_CONSTANT_NAME}', variable_name(identifier))
      end.join("\n"))
    end

    def view_controller_definitions
      prepend_title(VIEW_CONTROLLER_SECTION_TITLE, storyboard.view_controller_identifiers.sort.each_with_index.map do |identifier, index|
        StoryboardTemplates::VIEW_CONTROLLER_DEFINITION_TEMPLATE.gsub('{IDENTIFIER}', format_view_controller(identifier))
      end.join("\n"))
    end

    def view_controller_implementations
      prepend_title(VIEW_CONTROLLER_SECTION_TITLE, storyboard.view_controller_identifiers.sort.each_with_index.map do |identifier, index|
        StoryboardTemplates::VIEW_CONTROLLER_IMPLEMENTATION_TEMPLATE\
          .gsub('{IDENTIFIER}', variable_name(identifier))\
          .gsub('{CAPITALIZED_IDENTIFIER}', format_view_controller(identifier))
      end.join("\n"))
    end

    def variable_name identifier
      "_#{@prefix}#{identifier.gsub(/\W/,'').gsub(/\b\w/){ $&.downcase }}"
    end

    def format_view_controller identifier
      format(identifier, 'controller', 'ViewController', true)
    end

    def format_reuse_identifier identifier
      format(identifier, 'identifier', 'ReuseIdentifier')
    end

    def format_segue_identifier identifier
      format(identifier, 'segue|(segue)?identifier', 'SegueIdentifier')
    end

    def format identifier, suffix_matcher, suffix, capitalize=false
      formatted = identifier.gsub(/\W/,'_')
      unless formatted =~ /#{suffix_matcher}$/i
        formatted = "#{formatted}#{suffix}"
      end
      capitalize ? formatted.gsub(/\b\w/){ $&.upcase } : formatted
    end

    def prepend_title(title, text)
      if text.length > 0
        title = StoryboardTemplates::STORYBOARD_SECTION_TITLE_TEMPLATE.gsub('{TITLE}', title)
        "#{title}\n" + text
      else
        text
      end
    end
  end
end