module Dtu
  module DocumentHelperBehavior

    # Render field comprised of highlighted and non-highlighted values
    def render_highlight_field args
      document ||= args[:document]
      field = args[:field]
      all_values = args[:document][args[:field]]
      if document.has_highlight_field?(field)
        highlighted_values = document.highlight_field(field)
        highlighted_values.each do |highlighted|
          all_values.map! do |v|
            # if there is a highlighted version - use that
            if v == highlighted.gsub('<em>','').gsub('</em>','')
              highlighted
            else
              v
            end
          end
        end
      end
      all_values
    end


    def render_highlighted_abstract args
      document ||= args[:document]
      snippets = []
      field_value = (document['abstract_ts'] || ['No abstract']).first
      snippets << truncate(field_value, length: 300, separator:'')
      if document.has_highlight_field?('abstract_ts')
        highlights = document.highlight_field('abstract_ts').map {|hl| hl.html_safe}
        # if the first highlight is ~300 characters then use it as the main abstract value
        snippets[0] = highlights.shift if highlights.first.length > 297
        snippets += highlights
      end

      render_snippets(snippets)
    end

    def render_snippets(snippets)
      rendered_snippets = []
      snippets.each_with_index do |snippet, index|
        snippet = "...#{snippet}" unless index == 0 || snippet[0..2] == '...'
        snippet << "..." unless snippet[-3..-1] == '...'
        css_classes = ['snippet']
        css_classes << 'supplemental' if index > 0
        rendered_snippets << content_tag(:div, snippet.html_safe, :class => css_classes.join(' '))
      end
      rendered_snippets
    end
  end
end