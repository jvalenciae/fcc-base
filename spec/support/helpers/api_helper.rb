# frozen_string_literal: true

module ApiHelper
  def authenticated_header(user)
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end
end
