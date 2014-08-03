class String
  def to_plist
    to_json
  end
end

class Array
  def to_plist
    items = map { |item| "#{item.to_plist}" }
    "( #{items.join ","} )"
  end
end

class Hash
  def to_plist
    items = map { |key, value| "#{key.to_plist} = #{value.to_plist};\n" }
    "{ #{items.join} }"
  end
end
