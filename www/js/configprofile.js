$(function() {
    $(".removeline").click(function() {
	$(this).parent().remove();
    });

    $("#addline").click(function() {
	var rowhtml = '<div class="line"><a href="#" class="removeline">Remove</a>'; 
	rowhtml += '<input type="text" name="serverpath" />';
	rowhtml += '<input type="text" name="localpath" />';
	rowhtml += '</div>';
	
	var added = $(rowhtml).
	    insertBefore($(this).parent());
	
	added.children(".removeline").click(function() {
	    $(this).parent().remove();
	});
    });


    $('#realdeal').submit(function() {
	var maps = [];

	$('.line').map(function(){
	    var serverpath = $(this).children('input[name="serverpath"]').val();
	    var localpath = $(this).children('input[name="localpath"]').val();
	    maps.push({serverpath: serverpath, localpath: localpath});
	});

	$('#realdata').val(JSON.stringify({
	    maps : maps
	}));
	return true;
    });

    $('#submitid').click(function() {	
	$('#realdeal')[0].submit.click();
    });

/*    $('#puppet-one').on('submit', function() {	
	$('#realdeal').submit();	
	return false;
    });*/
});