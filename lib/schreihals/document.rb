module Schreihals
  class Document
    attr_reader :attributes

    def initialize(attrs = {})
      @attributes = {}.merge!(attrs)
    end

    def self.from_string(s)
      frontmatter, body = split_original_document(s)
      new(YAML.load(frontmatter).merge('body' => body.strip))
    end

    def self.from_file(name)
      from_string(open(name).read)
    end

    def self.split_original_document(s)
      s =~ /(.*)---\n(.*)\n---\n(.*)/m ? [$2, $3] : [nil, s]
    end

    def method_missing(name, *args)
      attributes[name.to_s] || super
    end
  end
end