$(function(){
    $(document).foundation();

    /**** tabs *****/
    $('.tabs li').on('click', function(){
        var content_to_show = $(this).data('content');

        //get ID from wrapping block
        var current_context = $(this).closest('.block').attr('id');

        //remove previous active classes
        $('#'+current_context+' .tabs li').removeClass('active');

        //add active class to current tab
        $(this).addClass('active');

        //hide content
        $('#'+current_context+' .tab__content').removeClass('active');

        //show content
        $('#'+content_to_show).addClass('active');
    });

    /**** type ahead ****/
    $('.typeahead').on('keyup', function(){
        var entered_val = $(this).val();
        var typeahead_elem = $('#search__typeahead__results');
        typeahead_elem.slideDown();
        //check amount of chars entered
        //if chars entered is < 3
        if(entered_val.length == 0){
            typeahead_elem.slideUp();
        }else if(entered_val.length > 0 && entered_val.length < 3){
            typeahead_elem.html('keep typing to search...')
        }else{ //else chars >= 3
            //make ajax requests and display results
            $.ajax({
                url: '/typeahead-search/'+entered_val,
                method: 'get'
            }).done(function(data) {
                if(data.status == 'OK'){
                    typeahead_elem.html(data.results);
                }else{
                    typeahead_elem.html('No results found...');
                }
            });
        }

    });

    /**** user dropdown ****/
    $('#current-user-dropdown').on('click', function(){
        var dropdown_elem = $('.users__dropdown');
        $.ajax({
            url: '/current-user-dropdown',
            method: 'get'
        }).done(function(data) {
            if(data.status == 'OK'){
                dropdown_elem.html(data.content);
                dropdown_elem.slideDown();
            }
        });
    });

    //close any typeahead open
    $('body').on('click', function(){
        $('#search__typeahead__results').slideUp();
    });

    //dim background
    $('.trigger-modal-bg').on('click', function(){
        $('body').append('<div class="reveal-modal-bg" style="display: block;"></div>');
    });

    //remove dim
    $('body').on("click",".reveal-modal-bg", function(){
        remove_dim();
        $('.users__dropdown').slideUp();
    });

    function remove_dim(){
        return $('.reveal-modal-bg').hide();
    }
});