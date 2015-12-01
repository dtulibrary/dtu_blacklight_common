module Dtu::DocumentPresenter::Metrics

  # Metrics that might be rendered for each document
  # Note that in DDF BL 5.16 upgrade we were not able
  # to assign class names to metrics config
  # therefore we add some extra code to convert string names to classes 
  # e.g. 'Dtu::Metrics::AltmetricPresenter' => Dtu::Metrics::AltmetricPresenter
  def metrics_presenter_classes
    classes = @configuration.try(:metrics_presenter_classes) || [Dtu::Metrics::AltmetricPresenter, Dtu::Metrics::IsiPresenter, Dtu::Metrics::DtuOrbitPresenter, Dtu::Metrics::PubmedPresenter]
    classes.map! do |klazz| 
      klazz.class == String ? klazz.try(:constantize) : klazz
    end
    classes
  end

  def metrics_presenters
    metrics_presenter_classes.map do |metrics_presenter_class|
      metrics_presenter_class.new(document, self, @configuration)
    end
  end

  # Check whether any metrics should be rendered for the document
  def has_metrics?
    document['format'] != 'journal' && metrics_presenters.any? { |metric_presenter| metric_presenter.should_render? }
  end

  # Render all metrics that apply for +document+
  def render_metrics
    metrics_content = []
    metrics_presenters.each do |metric_presenter|
      if metric_presenter.should_render?
        metrics_content << content_tag( 'div', metric_presenter.render, :class => 'metric' )
      end
    end
    metrics_content.join.html_safe
  end

end
