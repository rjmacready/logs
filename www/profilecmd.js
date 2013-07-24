function min(a, b){ return a > b ? b : a; };
function max(a, b){ return a > b ? a : b; };
function sizeFormatter(value) {
    if(value == 0)
	return '0.00';
    
    var neg = value < 0 ? 1 : 0;
    value = Math.abs(value);
    
    if(value < 1024)
	return (neg?'-':'') + value.toFixed(2) + 'B';
    
    value /= 1024;
    if(value < 1024)
	return (neg?'-':'') + value.toFixed(2) + 'KB';
    
    value /= 1024;
    if(value < 1024)
	return (neg?'-':'') + value.toFixed(2) + 'MB';
    
    value /= 1024;
    
    return (neg?'-':'') + value.toFixed(2) + 'GB';
};
Array.prototype.first = function(predicate, found, none) {
    if(!found || typeof found !== 'function') {
	throw new Error('found must be a function!');
    }
    
    for(var i = 0; i < this.length; ++i) {
	if(predicate(this[i], i, this)) {
	    found(this[i], i, this);
	}
    }
    if(none && typeof none === 'function') {
	none(this);
    }
};
function superLog (v) {
    if(v == 0.0)
	return 0.0;
    
    var sign = v < 0 ? -1 : 1;
    
    return sign * Math.log(Math.abs(v)); 			       
};	
function superExp (v) {
    if(v == 0.0)
	return 0.0;
    
    var sign = v < 0 ? -1 : 1;
    
    return sign * Math.exp(Math.abs(v)); 
};
var superLogBase = function(base) {
    var b = Math.log(base);
    return function (v) {
	if(v == 0.0)
	    return 0.0;
    
	var sign = v < 0 ? -1 : 1;
    
	return sign * Math.log(Math.abs(v)) / b;
    };
};

var superExpBase = function(base) {
    return function (v) {
	if(v == 0.0)
	    return 0.0;
	
	var sign = v < 0 ? -1 : 1;
	
	return sign * Math.pow(base, Math.abs(v)); 
    };
};
//var superLog10 = superLogBase(10);
//var superExp10 = superExpBase(10);

var plot = null;

$(function() {
    var chartData;

    var getDataTimeSpentFile = function(cb) {
	$.ajax({
	    type: 'GET',
	    url : '/rest/profile/byfile',
	    data: {
		id: cmdid
	    },
	    dataType: "json",
	    success: function(data) {
		console.log(data);

		var cdata = [];
		data.forEach(function(item) {
		    cdata.push({
			label: item.filename,
			data: item.cost
		    });
		});

		var options = {
		    series: {
			pie: {
			    show: true,
			    label: {
				show: false
			    }
			}
		    },
		    grid: {
			hoverable: true,
			clickable: true
		    },
		    legend: {
			show: false
		    }
		};
		
		cb(cdata, options, data);
	    }
	});
    };

    var getDataTimeSpentFunc = function(cb) {
	$.ajax({
	    type : 'GET',
	    url : '/rest/profile/timefunc',
	    data : {
		id: cmdid
	    },
	    dataType : "json",
	    success: function(data) {
		console.log(data);
		
		var d1 = [], d2 = [], d3 = [], i = 0;
		
		
		data.forEach(function(item) {
		    d1.push([i, item['sumInclCost']]);
		    d2.push([i, item['sumSelfCost']]);
		    //if()
		    var rc = item['ratioCost'];
		    d3.push([i, rc != 1.0 ? rc : null]);
		    
		    ++i;
		}); // item['functionName']
		
		var d = [{
		    data : d1,
		    label: 'Series 1',
		    bars : { show:true }
		}, {
		    data : d2,
		    label: 'Series 2',
		    bars : { show:true }
		}, {
		    data : d3,
		    label: 'Series 3',
		    //lines : { show:true },
		    points : { show:true },
		    yaxis : 2
		}];

		var _superLog = superLogBase(10);
		var _superExp = superExpBase(10);

		var opts = {
		    grid : {
			hoverable : true,
			clickable : true
		    },

		    yaxes: [{
			ticks : function(axis){
			    var _min = min(axis.min, 0), _max = axis.max;		    
			    var lmin = _superLog(_min), lmax = _superLog(_max);
			    var res = [], last = NaN;
			    
			    // powers of 10 ... :\ good enough i guess
			    
			    for(var i = 0; ; ++i) {
				last = _superExp(i);
				res.push([ last, last ]);
				if(last > axis.datamax)
				    break;
			    }

			    axis.min = 0; 
			    axis.max = last;
			    return res;
			},

			transform: _superLog,
			inverseTransform: _superExp,
		    }, {
			max: 1,
			min: 0,
			position: "right",
			tickFormatter: function(v){ return (v*100).toFixed() + '%';},
		    }]
		};
		
		cb(d, opts, data);
	    }
	});
    };

    $("#timespentfile").click(function() {
	getDataTimeSpentFile(function (data, options, original) {
	    plot = $.plot("#placeholder", data, options);	    


	    $("#placeholder").bind("plothover", function(event, pos, item) {
		if(!item) return;

		//console.log(event, pos, item);
		$('#info_selected').text(item.series.label);
	    });

	    $("#placeholder").bind("plotclick", function(event, pos, item) {
		//console.log(event, pos, item);
		if(!item) return;
		
		//var xcoord = item.datapoint[0];
		$('#info_selected').text(item.series.label);
	    });
	});
    });

    $("#timespentfunction").click(function() {
	getDataTimeSpentFunc(function(data, options, original) {
	    plot = $.plot('#placeholder', data, options);

	    $("#placeholder").bind("plotclick", function(event, pos, item) {
		if(!item) return;

		var xcoord = item.datapoint[0];
		original.first(function(t, idx) {
		    return idx == xcoord;
		}, function(row) {
		    $('#info_selected').text('Original row: ' + JSON.stringify(row));
		    
		    $.ajax({
			type : 'GET',
			url : '/rest/profile/line',
			data : {
			    'id' : traceid,
			    'function-name' : row['functionName']
			},
			
			success : function(rawdata) {
			    $('#more_info').text(rawdata);
			}
		    });		    
		});
	    });

	});
    });    
    
});