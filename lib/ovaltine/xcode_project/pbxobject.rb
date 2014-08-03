
module Ovaltine
  class XcodeProject
    class PBXObject < Hash
      attr_accessor :project_file
      attr_reader :uuid

      def self.filter array, attrs
        array.select do |obj|
          attrs.select { |k,v| obj[k] == v }.length == attrs.length
        end
      end

      def self.create_uuid
        uuid = ""
        24.times { uuid += "0123456789ABCDEF"[rand(16),1] }
        uuid
      end

      def initialize uuid, hash
        @project = nil
        @uuid = uuid
        self["isa"] = self.class.to_s.split('::').last
        hash.each { |k,v| self[k] = v }
      end

      def inspect
        @uuid + "=" + super
      end
    end
  end
end
