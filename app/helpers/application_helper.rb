module ApplicationHelper
  include FooterNavLinkHelper
  include ServiceDetailHelper

  def nav_item_class(path)
    'active' if current_page?(path)
  end

  def search_from?
    params[:q].present?
  end

  def default_meta_tags
    {
      site: t("site.name"),
      title: t("site.title"),
      reverse: true,
      separator: '|',
      description: t("site.description"),
      keywords: '自転車,ロードバイク,クロスバイク,サイクリング,サイクリスト,旅行,ツーリング,カスタムパーツ',
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      og: default_og,
      twitter: default_twitter_card,
      icon: [
        { href: image_url('charilog-favicon.png') }
      ]
    }
  end

  private

  def default_og
    {
      site_name: :site,
      title: :full_title,
      description: :description,
      type: 'website',
      url: request.original_url,
      image: image_url('charilog-ogp.png'),
      locale: 'ja_JP'
    }
  end

  def default_twitter_card
    {
      card: 'summary_large_image',
      site: '@Kiyo_newb_pg'
    }
  end
end
