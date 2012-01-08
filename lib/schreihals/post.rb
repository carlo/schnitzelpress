require 'tilt'

module Schreihals
  class Post < Document
    def initialize(*args)
      super
      self.attributes = {
        'disqus' => true,
        'status' => 'published',
        'summary' => nil,
        'link' => nil,
        'read_more' => nil,
        'date' => nil,
        'title' => nil,
        'slug' => nil
      }.merge(attributes)

      if file_name_without_extension =~ /^(\d{4}-\d{1,2}-\d{1,2})-?(.+)$/
        attributes['date'] ||= Date.parse($1)
        attributes['slug'] ||= $2
      else
        attributes['slug'] ||= file_name_without_extension
      end
    end

    def year
      date.year
    end

    def month
      date.month
    end

    def day
      date.day
    end

    def to_url
      date.present? ? "/#{year}/#{month}/#{day}/#{slug}/" : "/#{slug}/"
    end

    def disqus_identifier
      attributes['disqus_identifier'] || file_name
    end

    def disqus?
      disqus && published?
    end

    def published?
      status == 'published'
    end

    def post?
      date.present?
    end

    def page?
      !post?
    end
  end
end
