String.prototype.trim = function(){
	return this.replace(/(^\s+)|(\s+$)/g,'');
};

jQuery(document).ready(function($){
	var validation_remove = function(field){
		field.removeClass('error').parent().find('span.error').remove();
	};
	
	var validation_add = function(field, msg){
		validation_remove(field);
		field.addClass('error').parent().append('<span class="help-inline error">' + msg + '</span>');		
	};
	
	$.ajaxSetup({
		beforeSend: function(jqxhr, settings){
			$('<div class="alert alert-info" id="loading"><h4>Loading ...</h4></div>').hide().appendTo($('body')).fadeIn('fast');					
		},
		complete: function(jqxhr, status){
			$('body').find('#loading').fadeOut('fast').remove();				
		}		
	});

	$('#edit-form').on('submit', function(ev){
		var field = $('#user_name');

		if(field.val().trim().length == 0){
			validation_add(field, 'This field is required.');
			return false;
		}else{
			rv = true;
			
			$.ajax({
				url: '/users/available.json',
				dataType: 'json',
				data: {id: $('#user_id').val(), name: field.val().trim()},
				async: false,
				success: function(data, status, jqxhr){
					if(!data.reply){
						validation_add(field, 'The name is already taken.');
						rv = false;
					}
				},
				error: function(jqxhr, status, error){
					validation_add(field, 'Unable to check the user\'s name.');
					rv = false;
				}
			});

			return rv;
		}
	});
	
	$('#user_name').on('keypress', function(){
		validation_remove($(this));
	});
});
