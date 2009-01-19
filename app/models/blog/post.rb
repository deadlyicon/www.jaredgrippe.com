module Blog
  class Post < ActiveRecord::Base

    acts_as_taggable
  

    module Title
      def camelcase
        gsub(/\s+/,'_').camelcase
      end
      def camelize
        gsub(/\s+/,'_').camelcase
      end
    end
  
    def title
      read_attribute(:title).extend(Title)
    end
  
    PREVIEW_BREAK = '<div style="page-break-after: always; ">'
  
    def preview
      read_attribute(:body).split(PREVIEW_BREAK).first.chomp
    end
  
  end
end