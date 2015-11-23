require "dtu_blacklight_common/engine"
require 'blacklight'

module DtuBlacklightCommon
  extend ActiveSupport::Autoload
  autoload :CatalogBehavior
  autoload :Highlighting
end
