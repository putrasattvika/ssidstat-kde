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
