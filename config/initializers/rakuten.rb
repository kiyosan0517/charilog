RakutenWebService.configure do |c|
  if Rails.env.development?
    c.application_id = ENV['RWS_APPLICATION_ID_DEV']
    c.affiliate_id = ENV['RWS_AFFILIATION_ID_DEV']
  else
    c.application_id = ENV['RWS_APPLICATION_ID_PROD']
    c.affiliate_id = ENV['RWS_AFFILIATION_ID_PROD']
  end
end
