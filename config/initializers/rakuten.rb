RakutenWebService.configure do |c|
  if Rails.env.development? || Rails.env.test?
    c.application_id = ENV['RWS_APPLICATION_ID_DEV_AND_TEST']
    c.affiliate_id = ENV['RWS_AFFILIATION_ID_DEV_AND_TEST']
  else
    c.application_id = ENV['RWS_APPLICATION_ID_PROD']
    c.affiliate_id = ENV['RWS_AFFILIATION_ID_PROD']
  end
end
