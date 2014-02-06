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

var MovieApp = {
	secondsLeft: 10,
	startTimer: function(initial_time) {
		this.secondsLeft = initial_time;
		setInterval(function() { MovieApp.countDown() }, 1000);
	},
	countDown: function() {
		console.log(this.secondsLeft);
		document.getElementById("countdown_time").innerHTML = this.secondsLeft;
		if (this.secondsLeft === 0) {
			location.href = "/?timeout=true";
		}
		this.secondsLeft = this.secondsLeft - 1;
	}
}
