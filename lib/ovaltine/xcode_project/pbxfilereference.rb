
module Ovaltine
  class XcodeProject
    class PBXFileReference < PBXObject
      def self.create path, file_type
        self.new PBXObject.create_uuid, {
          "sourceTree" => "<group>",
          "path" => path,
          "lastKnownFileType" => file_type
        }
      end
    end
  end
end
