module SetTags
  def save_tags(sent_tags)
    current_tags = @post.tags.pluck(:name) unless @post.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      @post.tags.delete Tag.find_by(name: old)
      
      if (tag = Tag.find_by(name: old)) && tag.posts.size.zero?
        tag.destroy
      end
    end

    new_tags.each do |new|
      new_tag = Tag.find_or_create_by(name: new)
      @post.tags << new_tag
    end
  end
end