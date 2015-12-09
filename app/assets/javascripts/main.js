$(function(){
    $(document).foundation();

    /**** tabs *****/
    $('.tabs li').on('touchstart click', function(){
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
            $(this).closest('.users__profile__edit').css({'z-index': '1'});
            $('.users__profile__info__wrapper').css({'z-index': '1', 'padding': '0', 'width': 'auto'});
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

    //close any typeahead open
    $('body').on('touchstart click', function(){
        $('#search__typeahead__results').slideUp();
    });

    //dim background
    $('.trigger-modal-bg').on('touchstart click', function(){
        $('.reveal-modal-bg').show();
    });

    //remove dim
    $('body').on("touchstart click",".reveal-modal-bg", function(){
        remove_dim();
        $('.users__dropdown').slideUp();
        $('.users__notification').slideUp();
    });

    function remove_dim(){
        return $('.reveal-modal-bg').fadeOut();
    }
});