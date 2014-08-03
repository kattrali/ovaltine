
module Ovaltine
  class XcodeProject
    class PBXGroup < PBXObject

      def self.create name
        self.new(PBXObject.create_uuid, {
          "children" => [],
          "name" => name,
          "sourceTree" => "<group>"
        })
      end

      def add_object obj
        unless self["children"].include?(obj.uuid)
          self["children"] << obj.uuid
        end
      end

      def children recursive=false
        children = self.project_file.objects_with_uuids self["children"]

        if recursive
          subgroups = PBXObject.filter children, { "isa" => "PBXGroup" }
          subgroups.each { |subgroup| children << subgroup.children(true) }
        end

        children.flatten
      end
    end

    class PBXSourcesBuildPhase < PBXObject; end
    class PBXFrameworksBuildPhase < PBXObject; end
    class PBXResourcesBuildPhase < PBXObject; end
    class PBXNativeTarget < PBXObject; end
    class PBXProject < PBXObject; end
    class PBXContainerItemProxy < PBXObject; end
    class PBXReferenceProxy < PBXObject; end
    class XCBuildConfiguration < PBXObject; end
  end
end
