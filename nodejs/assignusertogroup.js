//node assignusertogroup.js user=guest password=mypass server=test01.lab.opentext.com  port=80 userGroupId=2 userId=3
var http = require('http');

if (process.argv.length <= 2) {
    process.exit(-1);
}
var args = process.argv.slice(2);
var server;
var port;
var username;
var password;
var userGroupId;
var userId;

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
    } else if (param[0] == "userGroupId") {
        userGroupId = param[1];
	} else if (param[0] == "userId") {
        userId = param[1];
    }
}

var authToken = new Buffer(username + ":" + password).toString('base64')


var optionsGet = {
    host: server,
    port: port,
    path: '/etx/api/v2/usergroups/' + userGroupId,
    method: 'GET',
    headers: {
        'Authorization': 'BASIC ' + authToken,
        'Content-Type': 'application/json'
    }
};

	

http.get(optionsGet, function (res) {
    console.log("Got response: " + res.statusCode);
    console.log('HEADERS: ' + JSON.stringify(res.headers));
    var data = '';
    res.on('data', function (chunk) {
        data += chunk;

    });
    res.on('end', function () {
        if (res.statusCode != "200") {
            console.log("error:no permssion or bad request!");
            return;
        }
		console.log("Get Result:"+data);
		var jsonData = JSON.parse(data);
		var existingMembers=jsonData.members;
        userGroupPut(existingMembers,userId);
    });


}).on('error', function (e) {
    console.log("Got error: " + e.message);
});


var optionsPut = {
	host: server,
	port: port,
	path: '/etx/api/v2/usergroups/' + userGroupId,
	method: 'PUT',
	headers: {
		'Authorization': 'BASIC ' + authToken,
		'Content-Type': 'application/json'
	}
};

function userGroupPut(existingMembers,userId) {
    var data = {};
	data.members=existingMembers+","+userId;

    var req = http.request(optionsPut, function (res) {
        console.log('STATUS: ' + res.statusCode);
        console.log('HEADERS: ' + JSON.stringify(res.headers));
    });

    req.on('error', function (e) {
        console.log("Got error: " + e.message);
    });
    var jsonDataPut = JSON.stringify(data);
	console.log("json data:");
	console.log(data);
    req.write(jsonDataPut);
    req.end();

}


