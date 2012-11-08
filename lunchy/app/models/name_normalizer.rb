class NameNormalizer
  def self.run name
    name.gsub(/(\S*)/) {|s| s.capitalize}
  end
end
