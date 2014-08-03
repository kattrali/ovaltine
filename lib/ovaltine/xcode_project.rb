
module Ovaltine
  class XcodeProject

    def load_dependencies
      unless @@loaded ||= false
        unless Object.const_defined?(:JSON)
          begin
            require 'json'
          rescue LoadError
            require File.expand_path(File.join(File.dirname(__FILE__),'../../vendor/json_pure/parser'))
            require File.expand_path(File.join(File.dirname(__FILE__),'../../vendor/json_pure/generator'))
          end
        end
        @@loaded = true
      end
    end

    def initialize path
      load_dependencies
      if path =~ /\.xcodeproj$/
        @path = File.join(path, 'project.pbxproj')
      else
        @path = path
      end
      @json = JSON.parse(`plutil -convert json -o - "#{@path}"`)

      @json["objects"].each do |uuid, hash|
        klass = PBXObject
        begin
          klass = Ovaltine::XcodeProject.const_get "#{hash['isa']}"
        rescue
        end

        obj = klass.new uuid, hash
        obj.project_file = self

        @json["objects"][uuid] = obj
      end
    end

    def save
      File.open(@path, "w") { |f| f.write @json.to_plist }
    end

    def objects
      @json["objects"].values
    end

    def groups
      objects_of_class(PBXGroup)
    end

    def files
      objects_of_class(PBXFileReference)
    end

    def objects_of_class klass
      str = klass.to_s.split('::').last
      objects.select {|obj| obj["isa"] == str }
    end

    def objects_with_uuids uuids
      uuids.map {|uuid| self.object_with_uuid uuid }
    end

    def object_with_uuid uuid
      @json["objects"][uuid]
    end

    def add_file_ref path
      relpath = File.expand_path(path).gsub(File.dirname(File.dirname(File.expand_path(@path))), '')[1..-1]
      relpath = relpath[(relpath.index('/') + 1)..-1]
      return nil if files.detect {|ref| ref["path"] == relpath}
      ref = PBXFileReference.create(relpath, file_type(path))
      add_object(ref)
      main_group = groups.detect do |g|
        !g["name"] && g["path"] && !g["path"].include?("Test")
      end
      unless group = groups.detect {|g| g["name"] == "Generated Files"}
        group = PBXGroup.create("Generated Files")
        add_object(group)
        main_group.add_object(group)
      end
      group.add_object(ref)
      ref
    end

    def add_object obj
      obj.project_file = self
      @json["objects"][obj.uuid] = obj
    end

    def file_type path
      file_type = 'sourcecode'
      if path =~ /\.m$/
        file_type = 'sourcecode.c.objc'
      elsif path =~ /\.h$/
        file_type = 'sourcecode.c.h'
      end
      file_type
    end
  end
end
