# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@tags.join(' ')} | #{APP_CONFIG[:site_name]}"
    xml.description "#{@tags.join(' ')} from #{APP_CONFIG[:site_url]}"
    xml.link formatted_blog_posts_url(:rss)
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.preview
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link blog_post_url(post)
        xml.guid blog_post_url(post)
      end
    end
  end
end