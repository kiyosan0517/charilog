module SetRakutenItems
  def save_items
    items_params&.each do |item|
      item_data = JSON.parse(item)

      item = if Item.exists?(item_code: item_data['item_code'])
                Item.find_by(item_code: item_data['item_code'])
             else
                Item.create(name: item_data['name'],
                            price: item_data['price'],
                            rakuten_url: item_data['rakuten_url'],
                            image: item_data['image'],
                            item_code: item_data['item_code'])
             end
      @post.post_items.create!(item: item)
    end
  end

  def items_params
    items = (1..4).map { |i| params[:post][:"items#{i}"] }.flatten.reject(&:empty?)
    items unless items.empty?
  end
end
