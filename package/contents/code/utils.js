function parseSSIDStat(stdout) {
    var j = JSON.parse(stdout);
    
    var parsed = {};
    parsed["adapters"] = [];
    parsed["data"] = {};

    for (var i = 0; i < j.length; i++) {
        parsed["adapters"].push(j[i]['Adapter']);
        parsed["data"][j[i]['Adapter']] = j[i];
    }

    return parsed;
}

function tabularSSIDStat(parsed) {
	var table = "";

	table += '<table">';
	table += '<tr>';
	table += '<th>Adapter</th>';
	table += '<th>SSID</th>';
	table += '<th>Bandwidth</th>';
	table += '</tr>';

    for (var i = 0; i < parsed["adapters"].length; i++) {
    	var adapter = parsed["adapters"][i];
    	var ssid = parsed["data"][adapter]["SSID"];
    	var bandwidth = parsed["data"][adapter]["Total"];

    	table += '<tr>';
		table += '<td>' + adapter +'</td>';
		table += '<td>' + ssid +'</td>';
		table += '<td>' + bandwidth +'</td>';
		table += '</tr>';
    }

    table += '</table>'

    return table;
}
