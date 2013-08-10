// settings
var FILE_ENCODING = 'utf-8',
	EOL = '\n';

// Dependencies
var _cli = require('commander'),
	_handlebars = require('hbs'),
	_minify = require('clean-css'),
	_fs = require('fs');


// Helper, will generate a CSV if package.json contains multiple licenses
_handlebars.registerHelper('license', function(items){
	items = items.map(function(val){
		return val.type;
	});
	return items.join(', ');
});

 // Logic
 // - concatinate all files
concat({
	src : [
		'css/_start.css',
		'css/reset.css',
		'css/normalize.css',
		'css/classes.css',
		'css/attributes.css',
		'css/touch.css'
	],
	dest : 'build/common.css'
});

// - Create / save minified file
minify('build/common.css', 'build/common-min.css');


//
// Methods
function concat(opts) {
	var fileList = opts.src;
	var distPath = opts.dest;

	var lib = fileList.map(function(filePath){
			return _fs.readFileSync(filePath, FILE_ENCODING);
		});

	var template = _handlebars.compile( lib.join(EOL) );

	//reuse package.json data and add build date
	var data = JSON.parse( _fs.readFileSync('package.json', FILE_ENCODING) );
	data.build_date = (new Date()).toUTCString();

	// Save uncompressed file
	_fs.writeFileSync(distPath, template(data), FILE_ENCODING);
	console.log(' '+ distPath +' built.');

}

function minify(srcPath, distPath) {
	/*
	var
	  jsp = uglyfyJS.parser,
	  pro = uglyfyJS.uglify,
	  ast = jsp.parse( _fs.readFileSync(srcPath, FILE_ENCODING) );

	ast = pro.ast_mangle(ast);
	ast = pro.ast_squeeze(ast);
	*/
	var source = _fs.readFileSync(srcPath, FILE_ENCODING);

	var result = _minify.process(source, {
		keepSpecialComments: 1,
		removeEmpty: true
	});

	_fs.writeFileSync(distPath, result, FILE_ENCODING);
	console.log(' '+ distPath +' built.');
}
