/**
* Activate jQuery autocomplete
* The autocomplete retrieves results from a SuggestController
* which in turn searches a request handler in Solr
**/
$(function() {
  $("[data-autocomplete-enabled='true']").autocomplete({
    source: function(request, response){
      $.ajax({
        url: $("[data-autocomplete-enabled='true']").data('autocompletePath'),
        data: { q: request.term },
        dataType: 'json',
        success: function(data){
          response($.map(data,function(item){
            return {
              label: item,
              value: item
            }
          }));
        },
        error: function(){
          console.log("error");
          response([]);
        }
      });
    },
    minLength: 2
  });
});
