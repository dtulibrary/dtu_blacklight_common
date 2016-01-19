require "dtu_blacklight_common/engine"
require 'blacklight'
require 'twitter-typeahead-rails'
require 'font-awesome-rails'

module DtuBlacklightCommon
  extend ActiveSupport::Autoload
  autoload :CatalogBehavior
  autoload :Highlighting
  autoload :DocumentHelper
end
