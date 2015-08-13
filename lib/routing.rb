module Routing
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    def default_url_options
      { host: ENV['HOST'] }
    end
  end
end
