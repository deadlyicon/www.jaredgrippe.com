module BlogHelper

  def blog_tag_path(tag)
    super tag.to_s.gsub(/\s/,'_')
  end
  
end
