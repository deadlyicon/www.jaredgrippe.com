namespace :db do
  desc "Erase and populate development database"
  task :populate => :environment do
    require 'ar-extensions'
    require 'faker'
    
    Blog::Post.delete_all
    
    data = []
    100.times do
      title = Faker::Lorem.sentence( rand(4) + 2 )
      title_slug = title.parameterize
      body = <<-BODY
        <p>#{Faker::Lorem.paragraphs( rand(4) + 1 ).join("</p>\n<p>")}</p>
        #{Blog::Post::PREVIEW_BREAK}
        <p>#{Faker::Lorem.paragraphs( rand(18) + 2 ).join("</p>\n<p>")}</p>
      BODY
      data.push [ title, title_slug, body ]
    end
    
    Blog::Post::PREVIEW_BREAK
      
    Blog::Post.import [:title, :title_slug, :body], data, :validate => false
    
    Blog::Post.all.each do |post|
      post.tag_list = Faker::Lorem.words( rand(6) + 2 ).join(", ")
      post.save
    end
    
  end
end