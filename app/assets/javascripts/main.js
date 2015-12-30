$(function(){
    $(document).foundation();
    /*** check if element is in view with this method ***/
    $.fn.inView = function(inViewType){
        var viewport = {};
        viewport.top = $(window).scrollTop();
        viewport.bottom = viewport.top + $(window).height();
        var bounds = {};
        bounds.top = this.offset().top;
        bounds.bottom = bounds.top + this.outerHeight();
        switch(inViewType){
            case 'bottomOnly':
                return ((bounds.bottom <= viewport.bottom) && (bounds.bottom >= viewport.top));
            case 'topOnly':
                return ((bounds.top <= viewport.bottom) && (bounds.top >= viewport.top));
            case 'both':
                return ((bounds.top >= viewport.top) && (bounds.bottom <= viewport.bottom));
            default:
                return ((bounds.top >= viewport.top) && (bounds.bottom <= viewport.bottom));
        }
    };
    /**** tabs *****/
    $('.tabs li').on('touchstart click', function(){
        var async_load = $(this).data('async-load');
        var content_to_show = $(this).data('content');
        var dom_to_update = $(this).data('dom');

        //get ID from wrapping block
        var current_context = $(this).closest('.block').attr('id');

        //remove previous active classes
        $('#'+current_context+' .tabs li').removeClass('active');

        //add active class to current tab
        $(this).addClass('active');

        //if async-load, make ajax call to load content
        if(async_load == true){
            $.ajax({
                url: '/load-content/'+content_to_show,
                method: 'get'
            }).done(function(data) {
                if(data.status == 'OK'){
                    $('#'+dom_to_update).html(data.content);
                }
            });
        }else{
            //hide content
            $('#'+current_context+' .tab__content').removeClass('active');

            //show content
            $('#'+content_to_show).addClass('active');
        }
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
    $('#current-user-dropdown').on('touchstart click', function(){
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

    /**** user dropdown ****/
    $('#current-user-notifications').on('touchstart click', function(){
        var dropdown_elem = $('.users__notification');
        $.ajax({
            url: '/current-user-notifications',
            method: 'get'
        }).done(function(data) {
            if(data.status == 'OK'){
                dropdown_elem.html(data.content);
                dropdown_elem.slideDown();
            }
        });
    });

    /*** edit user profile ***/
    $('#edit-user-profile').on('click', function(){
        var elem_to_mod = $('.users__profile__info__wrapper');
        $(this).removeClass('trigger-modal-bg');

        if($(this).hasClass('save-current-profile-changes')){
            $(this).removeClass('save-current-profile-changes');
            $(this).closest('.users__profile__edit').css({'z-index': '0'});
            $('.users__profile__info__wrapper').css({'z-index': '0', 'padding': '0', 'width': 'auto'});
            $(this).text('Edit Profile');

            //make ajax save changes and load up to read only content
            $.ajax({
                url: '/save-current-user-profile-info',
                method: 'post'
            }).done(function(data) {
                if(data.status == 'OK'){
                    elem_to_mod.html(data.content);
                }
            });

            remove_dim();
        }else{
            //Add class and toggle button texts
            $(this).toggleClass('save-current-profile-changes','');
            $(this).closest('.users__profile__edit').css({'z-index': '99999'});
            $('.users__profile__info__wrapper').css({'z-index': '99999', 'padding': '0.75rem', 'width': '115%'});
            $(this).text('Save Changes');

            //make ajax call to load up to date edits
            $.ajax({
                url: '/edit-current-user-profile-info',
                method: 'get'
            }).done(function(data) {
                if(data.status == 'OK'){
                    elem_to_mod.html(data.content);
                }
            });
        }
    });

    /*** tags input ***/
    $('.tags__input').tagEditor({placeholder: 'Separate each tags by a comma'});

    $('.add_tags').on('touchstart click', function(){
        $('.tag-editor').slideToggle();
    });

    /*** follow/unfollow user ***/
    $('.follow-unfollow').on('touchstart click', function(){
        //get user id
        var uid = $(this).data('uid');
        //make ajax call to run checks and update user

        //update button
        if($(this).hasClass('is_following')){
            $(this).text('Follow');
            $(this).removeClass('is_following');
        }else{
            $(this).text('Following');
            $(this).addClass('is_following');
        }
    });

    /*** remove user item ***/
    $('.remove-user-list').on('touchstart click', function(){
        //get user id
        var uid = $(this).data('uid');
        //make ajax call to update DB so as to mark the user do not want to see this feed again

        //remove/hide element
        $('#'+uid).fadeOut();
    });

    /*** handle ajax forms ***/
    $('.async-form-request').submit(function( event ) {
        var req_action = $(this).attr('action');
        var req_method = $(this).attr('method');
        var form_data = $(this).serialize();
        $.ajax({
            url: req_action,
            method: req_method,
            data: form_data
        }).done(function(data) {
            if(data.status == 'OK'){
                if(data.request_type == 'post-new-album-comment') {
                    //append new comment
                    $('#comments-for-album-' + data.album_token).append(data.content);
                    //clear comment box
                    $('input[name="comment"]').val('');
                }

                if(data.request_type == 'post-new-album-review') {
                    //discard modal
                    $('a.close-reveal-modal').trigger('click');
                    //update user
                    //or redirect user
                }

            }
        });
        event.preventDefault();
    });

    /*** rating ***/
    $('.can-rate').on('touchstart click', function(){
        //get the rating value
        var rating_val = $(this).data('rating');

        //clear any other active rating
        $('.can-rate').removeClass('active');

        //make this active
        $(this).toggleClass('active', '');
    });

    /*** infinite scrolling ***/
    $(window).on('scroll', function(){
        if ($('#infinite-album-feeds').inView('topOnly') && $(window).scrollTop() > $(document).height() - $(window).height() - 60){
            //get current page
            var current_page_feed = $('#current_page_feed');
            //make ajax call to get next set records
            $.ajax({
                url: 'load-more-album-feeds',
                method: 'get',
                data: {page: parseInt(current_page_feed.val())}
            }).done(function(data) {
                if(data.status == 'OK'){
                    $('#load-more-feeds').prepend(data.content);
                }
            });

            //increment next page
            current_page_feed.val(parseInt(current_page_feed.val()) + 1);
        }
    });

    //discard comment
    $('.discard-comment').on('touchstart click', function(){
        $('input[name="comment"]').val('');
    });

    //close any typeahead open
    $('body').on('touchstart click', function(){
        $('#search__typeahead__results').slideUp();
    });

    //dim background
    $('.trigger-modal-bg').on('touchstart click', function(){
        $('.modal__custom--reveal-bg').show();
    });

    //remove dim
    $('body').on("touchstart click",".reveal-modal-bg", function(){
        remove_dim();
    });

    $('body').on("touchstart click",".modal__custom--reveal-bg", function(){
        remove_dim();
    });
    function remove_dim(){
        $('.users__dropdown').slideUp();
        $('.users__notification').slideUp();
        $('.reveal-modal-bg').fadeOut();
        $('.modal__custom--reveal-bg').fadeOut();
        return true;
    }

});