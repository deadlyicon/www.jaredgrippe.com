module Blog
  class Post < ActiveRecord::Base

    acts_as_taggable

    # TODO fix this, maybe just validate?
    def before_save
      title_slug = title.parameterize
    end

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
    
    def title=(new_title)
      write_attribute(:title, new_title)
      write_attribute(:title_slug, new_title.parameterize.to_s)
    end

    PREVIEW_BREAK = '<div style="page-break-after: always; ">'

    def preview
      read_attribute(:body).split(PREVIEW_BREAK).first.chomp
    end
    
    def to_param
      "#{created_at.year}/#{created_at.month}/#{created_at.day}/#{title_slug}"
    end

  end
end