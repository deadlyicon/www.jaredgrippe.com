module Blog
  class Post < ActiveRecord::Base

    class << self
      
      def to_s
        class_name
      end
      
    end

    acts_as_taggable

    before_save do |post|
      post.write_attribute(:slug, "#{post.year}/#{post.month}/#{post.day}/#{post.title.parameterize}")
    end

    def self.find_by_param(slug, *options)
      find_by_slug(slug, *options)
    end
    
    def to_param
      slug
    end
    
    def created_at
      self[:created_at] ||= Time.now
    end
    
    def year
      created_at.year
    end
    def month
      created_at.month
    end
    def day
      created_at.day
    end
    
    PREVIEW_BREAKER = /<div\s+[^>]*style="[^"]*page-break-after:\s*always;[^"]*"[^>]*>/

    def preview
      body.split(PREVIEW_BREAKER).first
    end
    


  end
end