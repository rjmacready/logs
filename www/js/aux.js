
/*
 * For data from xdebug_code_coverage. Use for nothing else!
 */
function getArrayFromLineObj(obj) {
    var tmp = [], i = 0;
    
    for(var key in obj) {
	tmp[i++] = +key;
    }
    
    return tmp;
}

function updateHighlights() { 
    var old = [];
    return function(editor, lines) {
	console.log('new=', lines);
	
	old.forEach(function(idx) {
	    editor.removeLineClass(idx-1, "wrap",  "CodeMirror-activeline");
	    editor.removeLineClass(idx-1, "background", "CodeMirror-activeline-background");
	});
	lines.forEach(function(idx) {
	    editor.addLineClass(idx-1, "wrap",  "CodeMirror-activeline");
	    editor.addLineClass(idx-1, "background", "CodeMirror-activeline-background");
	});
	old = lines;
    };
}


function makeWidgets(editor, fulldata) {
    return function(widgets, filename) {
	return function() {
	    // TODO Gotta fix this. is doing nothing!
	    return;

	    for(var i = 0; i < widgets.length; ++i)
		editor.removeLineWidget(widgets[i]);
	    
	    widgets.length = 0;

	    console.log(filename, fulldata);

	    var obj = fulldata[filename];

	    console.log(obj);

	    for(var linedata in obj) {
		console.log('linedata', linedata);

		var yes = obj[linedata];
		console.log('yes', yes);

		if(yes == 1) {
		    var msg = document.createElement('div');
		    msg.innerText = "This line was executed";
		    
		    widgets.push(editor.addLineWidget(linedata, msg, {
			coverGutter: false, 
			noHScroll: true
		    }));	    
		}
	    }
	    return true;
	};
	return true;
    };
}