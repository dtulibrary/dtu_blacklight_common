
/*global Bloodhound */
$(document).ready(function() {

    'use strict';
    $('[data-autocomplete-enabled="true"]').each(function() {
        var $el = $(this);
        var suggestUrl = $el.data().autocompletePath;

        var terms = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.whitespace('term'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            sufficient: 1,
            remote: {
                url: suggestUrl + '?q=%QUERY',
                wildcard: '%QUERY'
            }
        });

        //terms.initialize();

        $el.typeahead({
                hint: true,
                highlight: true,
                minLength: 2,
                async: true,
                limit: 5
            },
            {
                name: 'terms',
                displayKey: 'term',
                source: terms.ttAdapter()
            });
    });
});

