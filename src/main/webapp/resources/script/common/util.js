
const getParamMap = function() {
	return location.search.replace('?', '').split('&').reduce((acc, e) => {
	    let [k, v] = e.split('=');
	    acc[k] = v;
	    return acc;
	}, {});
}

jQuery.prototype.countNumber = function(start, end, callback={}) {
	let t=$(this);
	
	start = !isNaN(parseInt(start)) ? parseInt(start) : (parseInt($(this).text().replaceAll(',', '')) || 0);
	end =  !isNaN(parseInt(end)) ? Number(end) : 0;
	
	if(start !== end) {
		$({num:start}).animate({num:end}, {
		    duration: 1e3,
		    easing: 'swing',
		    step: function() {
		    	if(!callback.step) t.text(parseInt(this.num));
		        else callback.step(t, start, end);
		    },
		    complete: function() {
		    	if(!callback.complete) t.text(end);
		        else callback.complete(t, start, end);
		    }
		});
	}
	return t;
}