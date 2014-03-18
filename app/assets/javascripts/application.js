// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var ready = function(){
	function getURLParameter(name) {
  		return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
	}
	question_text = getURLParameter('question_text');
	if(question_text != null && question_text.length > 0){
		$("#question_question_text").val(question_text);
	}

	$('#search_from_date').datepicker({ 
		dateFormat: "dd/mm/yy", 
		onSelect: function(selected) {
          $("#search_till_date").datepicker("option","minDate", selected)
        }});
	$('#search_till_date').datepicker({ 
		dateFormat: "dd/mm/yy", 
		onSelect: function(selected) {
           $("#search_from_date").datepicker("option","maxDate", selected)
        }
	});
	
	$('#refresh').on("click", function(e){
		e.preventDefault();
		question_text = $("#question_question_text").val();
		window.location = "/questions/new?question_text=" + question_text;
	})
	
};
$(document).on('page:load', ready);
$(document).on('page:change', ready);
