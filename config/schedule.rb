# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path("#{File.dirname(__FILE__)}/environment") # Rails.root(Railsメソッド)を使用するために必要
rails_env = ENV['RAILS_ENV'] || :development # cronを実行する環境変数(:development, :product, :test)
set :environment, rails_env # cronを実行する環境変数をセット
set :output, Rails.root.join('log/crontab.log') # cronのログ出力用ファイル

every :hour do # タスクの実行間隔
  rake 'unattached_images:purge', environment: ENV['RAILS_ENV'] # ← rake "タスクのファイル名 : タスク名"
end

every 1.day, at: '9:00 am' do
  rake 'notifications:check_the_next_date', environment: ENV['RAILS_ENV']
end
