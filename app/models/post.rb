class Post < ActiveRecord::Base

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
  
end
