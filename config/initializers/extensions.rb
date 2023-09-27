# frozen_string_literal: true

Dir[Rails.root.join('lib/extensions/**/*.rb')].sort.each { |extension| require extension }
