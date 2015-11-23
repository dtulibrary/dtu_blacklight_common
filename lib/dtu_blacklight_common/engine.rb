module DtuBlacklightCommon
  class Engine < ::Rails::Engine

    config.autoload_paths += %W(
      #{config.root}/app/presenters/concerns #{config.root}/app/helpers/concerns
    )

  end
end
