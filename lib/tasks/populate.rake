namespace :db do
  desc "Erase and populate development database"
  task :populate => :environment do
    require 'ar-extensions'
    require 'faker'
    
    Post.delete_all
    
    data = []
    100.times do
      title = Faker::Lorem.sentence( rand(6) + 2 )
      body = <<-BODY
        <p>#{Faker::Lorem.paragraphs( rand(4) + 1 ).join("</p>\n<p>")}</p>
        #{Post::PREVIEW_BREAK}
        <p>#{Faker::Lorem.paragraphs( rand(18) + 2 ).join("</p>\n<p>")}</p>
      BODY
      data.push [ title, body ]
    end
    
    Post::PREVIEW_BREAK
      
    Post.import [:title, :body], data, :validate => false
  end
end