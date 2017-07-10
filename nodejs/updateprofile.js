//node updateprofile.js user=username password=password server=etx.mycompany.org  port=80 id=18 TargetNode="Single>www.test.com" EnableLog=1 LogFont=0
var http = require('http');

if (process.argv.length <= 2) {
    process.exit(-1);
}
var args = process.argv.slice(2);
var server;
var port;
var username;
var password;
var id;
var modifiedAttributes = [];

for (var i = 0; i < args.length; i++) {
    var param = args[i].split("=");
    if (param[0] == "server") {
        server = param[1];
    } else if (param[0] == "port") {
        port = param[1];
    } else if (param[0] == "user") {
        username = param[1];
    } else if (param[0] == "password") {
        password = param[1];
    } else if (param[0] == "id") {
        id = param[1];
    } else {
		var attrObj = {};
		attrObj.name=param[0];
		attrObj.value=param[1];
        modifiedAttributes.push(attrObj);
    }
}

var authToken = new Buffer(username + ":" + password).toString('base64')
var data={};
data.id=id;
data.attributes = modifiedAttributes;


var optionsPut = {
    host: server,
    port: port,
    path: '/etx/api/v2/profiles/' + id,
    method: 'PUT',
    headers: {
        'Authorization': 'BASIC ' + authToken,
        'Content-Type': 'application/json'
    }
};


var req = http.request(optionsPut, function (res) {
	console.log('STATUS: ' + res.statusCode);
	console.log('HEADERS: ' + JSON.stringify(res.headers));
});

req.on('error', function (e) {
	console.log("Got error: " + e.message);
});
var jsonDataPut = JSON.stringify(data, null, 4);
console.log("json data:");
console.log(jsonDataPut);
req.write(jsonDataPut);
req.end();
