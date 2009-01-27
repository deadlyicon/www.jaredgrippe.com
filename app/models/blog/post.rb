module Blog
  class Post < ActiveRecord::Base

    class << self
      
      def to_s
        class_name
      end
      # 
      # def find(*args)
      #   if args.first.match(/^\n+\/\n+\/\n+\/.*/)
      #   
      # end
      
    end

    acts_as_taggable

    # TODO fix this, maybe just validate?
    before_save do |post|
      post.write_attribute(:slug, "#{post.year}/#{post.month}/#{post.day}/#{post.title.to_slug}")
    end

    module Title
      def camelcase
        gsub(/\s+/,'_').camelcase
      end
      def camelize
        gsub(/\s+/,'_').camelcase
      end
      def to_slug
        parameterize
      end
    end

    def title
      read_attribute(:title).clone.extend(Title)
    end
    
    # def slug=(*args)
    #   raise ArgumentError, 'slugs are generated '
    # end
    
    # def to_param
    #   slug
    # end
    # 
    def year
      created_at.year
    end
    def month
      created_at.month
    end
    def day
      created_at.day
    end
    
    # TODO make this a Regex
    PREVIEW_BREAKER = /<div\s+[^>]*style="[^"]*page-break-after:\s*always;[^"]*"[^>]*>/

    def preview
      body.split(PREVIEW_BREAKER).first
    end
    


  end
end