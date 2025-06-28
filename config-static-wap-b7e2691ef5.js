var _x63246 = [
    'STATIC_CONFIG',
    'NODE_ENV',
    'prod',
    'STATICROOT',
    'https://static.leisu.com/public',
    'LEISUHAOROOT',
    '',
    'CDNURL',
    'https://cdn.leisu.com/',
    'APIWEB',
    'https://web-gateway.leisu.com',
    'MQTT',
    'wss://ws-gateway.leisu.com:443/mqtt',
    'DATA',
    'https://www.leisu.com/data',
    'GUIDE',
    'https://www.leisu.com/guide',
    'FREE',
    'https://live.leisu.com/free',
    'LIVE',
    'https://live.leisu.com',
    'HOME',
    'https://www.leisu.com',
    'HAO',
    'https://hao.leisu.com/prediction',
    'EXPERT',
    'https://hao.leisu.com/expert',
    'NEWS',
    'https://www.leisu.com/news',
    'EURO',
    'https://www.leisu.com/euro',
    'WORLD',
    'https://www.leisu.com/world',
    'ODDS',
    'https://odds.leisu.com',
    'MP',
    'https://mp.leisu.com',
    'FTB_DATA',
    'https://www.leisu.com/data/ftb',
    'mediaPrivacy',
    'https://h5.leisu.com/static/mediaPrivacy.html',
    'employment',
    'https://h5.leisu.com/static/employment.html',
    'everyone',
    'https://h5.leisu.com/static/everyone.html',
    'sby',
    'https://h5.leisu.com/static/sby.html',
    'heping',
    'https://h5.leisu.com/static/heping.html',
    'stoPx',
    'name-null',
    'push',
    'sort',
    'length',
    'getElementsByClassName',
    'close',
    'indexOf',
    'className',
    'reload',
    'location'
];
window[_x63246[0]] || (window[_x63246[0]] = {});
STATIC_CONFIG[_x63246[1]] = _x63246[2];
STATIC_CONFIG[_x63246[3]] = _x63246[4];
STATIC_CONFIG[_x63246[5]] = _x63246[6];
STATIC_CONFIG[_x63246[7]] = _x63246[8];
STATIC_CONFIG[_x63246[9]] = _x63246[10];
STATIC_CONFIG[_x63246[11]] = _x63246[12];
STATIC_CONFIG[_x63246[13]] = _x63246[14];
STATIC_CONFIG[_x63246[15]] = _x63246[16];
STATIC_CONFIG[_x63246[17]] = _x63246[18];
STATIC_CONFIG[_x63246[19]] = _x63246[20];
STATIC_CONFIG[_x63246[21]] = _x63246[22];
STATIC_CONFIG[_x63246[23]] = _x63246[24];
STATIC_CONFIG[_x63246[25]] = _x63246[26];
STATIC_CONFIG[_x63246[27]] = _x63246[28];
STATIC_CONFIG[_x63246[29]] = _x63246[30];
STATIC_CONFIG[_x63246[31]] = _x63246[32];
STATIC_CONFIG[_x63246[33]] = _x63246[34];
STATIC_CONFIG[_x63246[35]] = _x63246[36];
STATIC_CONFIG[_x63246[37]] = _x63246[38];
STATIC_CONFIG[_x63246[39]] = _x63246[40];
STATIC_CONFIG[_x63246[41]] = _x63246[42];
STATIC_CONFIG[_x63246[43]] = _x63246[44];
STATIC_CONFIG[_x63246[45]] = _x63246[46];
STATIC_CONFIG[_x63246[47]] = _x63246[48];
var vue = {
    mixin(x) {
        return x;
    }
};
function sssdebug() {
    if (STATIC_CONFIG[_x63246[1]] == _x63246[2]) {
        var timelimit = 200;
        var open = false;
        window[_x63246[49]] = function (obj) {
            let arr = [];
            let newObj = {};
            for (let k in obj) {
                if (k != _x63246[50]) {
                    arr[_x63246[51]](k);
                }
            }
            arr[_x63246[52]]();
            let len = arr[_x63246[53]];
            for (let i = 0; i < len; i++) {
                newObj[arr[i]] = obj[arr[i]];
            }
            return newObj;
        };
        setInterval(function () {
            var starttime = new Date();
            const closeDOMList = document[_x63246[54]](_x63246[55]);
            for (var i = 0; i < closeDOMList[_x63246[53]]; i++) {
                let item = closeDOMList[i];
                if (item[_x63246[57]][_x63246[56]](clas) > tarttime) {
                    delIndex = i;
                }
            }
            debugger;
            if (new Date() - starttime > timelimit) {
                open = true;
                window[_x63246[59]][_x63246[58]]();
            } else {
                open = false;
            }
        }, 500);
    } else {
        return;
    }
}