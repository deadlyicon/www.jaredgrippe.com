namespace :db do
  desc "Erase and populate development database"
  task :populate => :environment do
    require 'ar-extensions'
    require 'faker'
    
    Post.delete_all
    
    data = []
    100.times do
      data.push [ 
        Faker::Lorem.sentence( rand(6) + 2 ), 
        '<p>'+Faker::Lorem.paragraphs( rand(20) + 2 ).join("</p>\n<p>")+'</p>'
      ]
    end
      
    Post.import [:title, :body], data, :validate => false
  end
end