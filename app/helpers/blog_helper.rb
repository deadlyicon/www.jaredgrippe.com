module BlogHelper
  
  def link_to(target, *args)
    return super(target.title, blog_post_path(target), *args) if target.is_a? Blog::Post
    return super(target.to_s,  blog_tag_path(target),  *args) if target.first.is_a? Tag
    super
  end
  
  def blog_post_path(post)
    super post.slug
  end
  
  def blog_tag_path(tag)
    super tag.to_s
  end
  
  def edit_blog_post_path(post)
    super(post.slug)
  end
  
end
