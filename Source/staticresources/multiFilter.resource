(function($) {
    $.fn.multiFilter = function(filters) {
        var $table = $(this);
        return $table.find('tbody > tr').each(function() {
            var tr = $(this);
            
            // Make it an array to avoid special cases later.
            if(!$.isArray(filters))
                filters = [ filters ];

            howMany = 0;
            for(i = 0, f = filters[0]; i < filters.length; f = filters[++i]) {
                var index = 0;
                $table.find('thead > tr > th').each(function(i) {
                    if($(this).text() == f.column) {
                        index = i;
                        return false;
                    }
                });
                var text = tr.find('td:eq(' + index + ')').text();
                if(text.toLowerCase().indexOf(f.word.toLowerCase()) != -1)
                    ++howMany;
            }
            if(howMany == filters.length)
                tr.show();
            else
                tr.hide();
        });
    };
})(jQuery);