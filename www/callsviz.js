'strict';
var nodes = [];
var lines = [];

$(function() {   


    
    var stage = new Kinetic.Stage({
        container: 'container',
        width: 600,
        height: 600
    });

    var bkground = new Kinetic.Layer();
    bkground.add(new Kinetic.Rect({
	x: 0,
	y: 0,
	width: 600,
	height: 600,
	fill: 'yellow'
    }));
    stage.add(bkground);
    bkground.draw();
    
    var clamp = function(v, min, max) {
	return Math.min(Math.max(v, min), max);
    };
   
    var drawCall = function(id, name, parent) {
	//console.log(id, name);
	var layer = new Kinetic.Layer({
	    draggable: true
	});
	stage.add(layer);

	var rect = new Kinetic.Rect({
	    x: clamp(Math.random() * 600, 50, 550), 
	    y: clamp(Math.random() * 600, 50, 550),
	    width: 50, 
	    height: 50,
	    fill: 'lightblue',
	    id : id
	});
	nodes[id] = rect;
	
	var tx = new Kinetic.Text({
	    align: 'center',
	    text: name,
	    fill: 'black',
	    x: rect.getX(),
	    y: rect.getY(),
	    width: 50,
	    height: 50,
	    listening: false
	});

	if(typeof parent !== 'undefined') {
	    // draw arrow
	    var myParent = nodes[parent];
	    var line = new Kinetic.Line({
		points: [
		    myParent.parent.getX() + myParent.getX() + 25, 
		    myParent.parent.getY() + myParent.getY() + 25,
		    rect.getX() + 25, 
		    rect.getY() + 25],
                stroke: 'black',
                strokeWidth: 1,
                lineCap: 'round',
                lineJoin: 'round',
		draggable: false
	    });
	    bkground.add(line);

	    lines[{ parent: parent, target: id }] = line;
	}
	
	//tx.on('click', function(evt){ evt.cancelBubble = false; });
	var alreadyLoaded = false;
	rect.on('dblclick', function() {
	    if(alreadyLoaded)
		return;
	    
	    getChildsOf(id, function(data) {
		drawCall(data['functionNo'], data['functionName'], data['parent']);
	    });
	    
	    alreadyLoaded = true;
	});
	
	layer.add(rect);
	layer.add(tx);
	bkground.draw();
	layer.draw();
    };

    // get base one
    var getChildsOf = function(parentid, cb) {
	$.ajax({
	    url: '/rest/trace/get-childs-of',
	    data: {
		id: traceid,
		parent: parentid
	    },
	    dataType: 'json',
	    success: function(data) {
		data.forEach(cb);
	    }
	});	
    };
    var getRoot = function (cb) {
	$.ajax({
	    url: '/rest/trace/get-root',
	    data: {
		id: traceid
	    },
	    dataType: 'json',
	    success: function(data) {
		cb(data);
	    }
	});
    };
    
    getRoot(function(data) {
	console.log(data);
	drawCall(data['functionNo'], data['functionName']);
    });
});