module ApplicationHelper
  include FooterNavLinkHelper
  include ServiceDetailHelper

  def nav_item_class(path)
    'active' if current_page?(path)
  end

  def sort_active_class(option)
    current_order = params[:order]
    'active' if current_order == option
  end

  def link_to_sort(name, url, options = {})
    link_to(name, url, options.merge(data: { turbolinks: false }))
  end

  def search_from?
    params[:q].present?
  end

  def default_meta_tags
    {
      site: t('site.name'),
      title: t('site.title'),
      reverse: true,
      separator: '|',
      description: t('site.description'),
      keywords: '自転車,ロードバイク,クロスバイク,サイクリング,サイクリスト,旅行,ツーリング,カスタムパーツ',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
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

  def x_share_post_template(name, created_at)
    "#{CGI.escape(name)}さんのログを覗いてみよう！[投稿日: #{created_at}]%0a%23ChariLog%20%23ロードバイク%20%23クロスバイク%20%23自転車旅行%20%23サイクリング%20%23カスタムパーツ"
  end

  def x_share_user_template(name)
    "#{CGI.escape(name)}さんのログ一覧%0a%23ChariLog%20%23ロードバイク%20%23クロスバイク%20%23自転車旅行%20%23サイクリング%20%23カスタムパーツ"
  end

  def line_share_post_template(name, created_at)
    "#{CGI.escape(name)}さんのログを覗いてみよう！[投稿日: #{created_at}] - ChariLog(チャリログ)"
  end

  def line_share_user_template(name)
    "#{CGI.escape(name)}さんのログ一覧 - ChariLog(チャリログ)"
  end
end
