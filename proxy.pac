/* vim: set ft=javascript: */

// Author: Allex (allex.wxn@gmail.com)
// Last Modified: Fri Feb 10, 2012 04:27PM
//
// see also:
//   http://findproxyforurl.com/pac_file_examples.html
//   http://findproxyforurl.com/pac_functions_explained.html

var DIRECT      = 'DIRECT';
var CORPHOLE    = 'PROXY 192.168.100.221:80';
var LOCALHOLE   = 'PROXY proxy:8888';

// Set debug to level you want status alerts for testing
var debugNone     = 0;    // No debuging alerts.
var debugGeneral  = 0x01; // Show alert when file is loaded.
var debugShowPass = 0x02; // Show all URLS that pass and why.
var debugShowFail = 0x04; // Show all URLS that fail and why.
var debugRegxGen  = 0x08; // Show Regx expressions generated.
var debugModURL   = 0x10; // Show removal of CGI args and anchors from URL.
var debugShowIP   = 0x20; // Show when we find an IP numeric address.
var debugNormal   = debugGeneral | debugShowFail;
var debugAll      = debugGeneral | debugShowPass | debugShowFail | debugRegxGen | debugModURL | debugShowIP;

// WARNING:  Opera, Konqueror, AND Safari USERS MUST NEVER SET DEBUG TO
// ANYTHING OTHER THAN debugNone.  THE alert() CALL CAUSES THEM TO FAIL!
var debug = debugNone;

// Add any good networks here. Format is network folowed by a comma and
// optional white space, and then the netmask.
var resolvesIPs = [
	['10.0.0.0', '255.0.0.0'],
	['127.0.0.0', '255.255.255.0'],
	['172.16.0.0', '255.240.0.0'],
    ['192.168.0.0', '255.255.0.0']
];

function isResolveHost(host) {
	var resolved_ip = dnsResolve(host), length = resolvesIPs.length, arr;
// corp public proxy server name.
    if (resolved_ip === '192.168.100.221') return false;
    while (length--) {
        arr = resolvesIPs[length];
        if (isInNet(resolved_ip, arr[0], arr[1])) return true;
    }
    return false;
}

function isBlockedDnsDomain(host) {
    return (0
        // || dnsDomainIs(host, '.twimg.com')
        || dnsDomainIs(host, '.twitter.com')
    );
}

function checkShExpMatch(url) {
    return (0
        || shExpMatch(url, '*tw.yahoo.com/*')
        || shExpMatch(url, '*tw.*.yahoo.com/*')
        || shExpMatch(url, '*twitter.com*')
        || shExpMatch(url, '*abcdomain.com/folder/*')
        || shExpMatch(url, '*vpn.domain.com*')
    );
}

var re_IpAddrRegx = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
function isNumIpAddr(host) {
    var ipArr = host.match(re_IpAddrRegx), isIPValid = false;

    if (ipArr) {
        isIPValid = true;
        for (var i = 1; i <= 4; i++) {
            if (ipArr[i] >= 256) {
                isIPValid = false;
                break;
            }
        }
    }

    if (debug & debugShowIP && isIPValid) {
        log('Found a IP host address: ' + host);
    }

    return isIPValid;
}

function log(s) {}

function FindProxyForURL(url, host) {

    if (url.substr(0, 4) == 'ftp:') return DIRECT;

//Ignore Local Servers
    if (isPlainHostName(host)) return DIRECT;

    var result,
        isNumIP = isNumIpAddr(host),
        hasIPv4Address = true,
        iPv4Address,
        str = url.match(/^[^\?#]*/);

    if (str != url) {
        if (debug & debugModURL) {
            log('URL modified:\n' + url + '\n' + str);
        }
        url = str;
    }

    if (isNumIP) {
        iPv4Address = host;
    } else {

// If IP address is internal or hostname resolves to internal IP, send direct.
        if (isResolvable(host)) {
            iPv4Address = dnsResolve(host);
        } else {
            hasIPv4Address = false;
        }
    }

    if (hasIPv4Address && isResolveHost(host)) {
        return DIRECT;
    }

// Check blocked dns domain.
    if (isBlockedDnsDomain(host)) return LOCALHOLE;

// Attempt to match hostname or URL to a specified shell expression.
    if (checkShExpMatch(url)) return LOCALHOLE;

    return DIRECT;
}
