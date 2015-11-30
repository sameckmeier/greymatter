$(function(){
    $(document).foundation();

    //tabs
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
});