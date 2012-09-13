/**
 * Unpack the codes which packed by Dean Edwards' Packer
 * Add by allex_wang (allex.wxn@gmail.com)
 */ 
var rePacker = /eval\(function\(p,a,c,k,e,r\){.+?\.split\('\|'\),0,\{\}\)\)(?=;?)/;

function unpack(text) {
    var match, offset = 0, j = -1, buffer = [];
    while (text) {
        if (match = text.match(rePacker)) {
            offset = match.index;
            buffer[++j] = text.substring(0, offset);
            buffer[++j] = eval('String(' + match[0].slice(5, -1) + ')');
            text = text.substring(offset + match[0].length);
        } else {
            buffer[++j] = text;
            text = '';
        }
    }
    return buffer.join('');
}

exports.unpack = unpack;
