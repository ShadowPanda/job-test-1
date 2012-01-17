// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

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
			$('<div class="alert-message warning" id="loading"><h1>Loading ...</h1></div>').appendTo('body');					
		},
		complete: function(jqxhr, status){
			$('body').find('#loading').remove();
		}		
	});
	
	return;
	$('#edit-form').on('submit', function(ev){
		var field = $('#user_name');

		if(field.val().trim().length == 0){
			validation_add(field, 'This field is required.');
			return false;
		}else{
			$('<div class="alert-message warning" id="loading"><h3>Loading ...</h3></div>').appendTo('body');
			
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