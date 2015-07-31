module HttpsHelper
  def with_https_enabled
    Rails.application.routes.default_url_options[:protocol] = "https"
    ENV['ENABLE_HTTPS'] = 'yes'
    yield
    ENV['ENABLE_HTTPS'] = 'no'
    Rails.application.routes.default_url_options[:protocol] = "http"
  end
end
