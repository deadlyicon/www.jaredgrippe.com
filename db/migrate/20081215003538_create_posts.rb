class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :title_slug
      t.text :body

      t.timestamps
    end
  end
  #TODO add indexes

  def self.down
    drop_table :posts
  end
end
