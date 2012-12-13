/* vim: set ft=javascript tw=75 sw=4: */
/*!-------------------------------------------------------------------

 Author: Allex (allex.wxn@gmail.com)
 Last Modified: Thu Dec 13, 2012 10:22PM

 see also:
 http://findproxyforurl.com/pac_file_examples.html
 http://findproxyforurl.com/pac_functions_explained.html

--------------------------------------------------------------------*/
<?php

define("PROXY_DIRECT", "DIRECT");

function ping($server, $port, $deep = TRUE) {
    $socket = @fsockopen($server, $port, $errno, $errstr, 0.4);
    if ($socket) {
        fclose($socket);
        return true;
    }
    return false;
}

header('Content-Type: text/javascript; charset=utf-8');

// main proxy server host.
$proxyServer = 'proxy';

// reserve proxy server.
$reserveHost = '192.168.100.221';

// lan ip address
$ip = exec(getenv('bin').'/ip');
if (!$ip) $ip = '127.0.0.1';

$freeProxy = PROXY_DIRECT;
$fiddlerProxy = PROXY_DIRECT;

// goagent proxy
if (ping($proxyServer, 8087, FALSE)) {
    $freeProxy = "PROXY $proxyServer:8087";
} else {
    // free gate
    if (ping($proxyServer, 8580)) {
        $freeProxy = "PROXY $proxyServer:8580";
    } else {
        // lan proxy
        if (ping($reserveHost, '80')) {
            $freeProxy = "PROXY $reserveHost:80";
        }
    }
}

if (ping($proxyServer, 8888)) {
    $fiddlerProxy = "PROXY $proxyServer:8888";
}

$localProxy = PROXY_DIRECT;
if (ping($proxyServer, 8581)) {
    $localProxy = "PROXY $proxyServer:8581";
}

echo "\n// timestamp: " . md5(microtime(true)) . "\n";
?>

(function(exports) {

var LAN_IP       = '<?=$ip?>';
var LAN_PROXY_IP = '192.168.100.221';
var DIRECT       = '<?=PROXY_DIRECT?>';
var PROXY_LAN    = 'PROXY ' + LAN_PROXY_IP + ':80';
var PROXY_FREE   = '<?=$freeProxy?>';
var PROXY_DEBUG  = '<?=$fiddlerProxy?>';
var PROXY_LOCAL  = '<?=$localProxy?>';

// WARNING:  Opera, Konqueror, AND Safari USERS MUST NEVER SET DEBUG TO
// ANYTHING OTHER THAN debugNone.  THE alert() CALL CAUSES THEM TO FAIL!
var debug = 0;

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
    // corp public proxy server.
    if (resolved_ip === LAN_PROXY_IP) {
        return false;
    }
    while (length--) {
        arr = resolvesIPs[length];
        if (isInNet(resolved_ip, arr[0], arr[1])) return true;
    }
    return false;
}

function isFiddlerMatch(url, host) {
    return (0
        || shExpMatch(url, '*.127.net/*')
        || shExpMatch(url, '*.163.com/*')
        || dnsDomainIs(host, 'm.sinaimg.cn')
        || (dnsDomainIs(host, '.sina.com.cn') && url.indexOf('internal') === -1)
        || dnsDomainIs(host, '.sinaimg.cn')
        || dnsDomainIs(host, '.weibo.com')
    );
}

function isLocalProxy(url, host) {
    return false;
}

function isBlockedDnsDomain(host) {
    return (0
        || dnsDomainIs(host, 'twimg.com')
        || dnsDomainIs(host, 'twitter.com')
        || dnsDomainIs(host, 't.co')
        || dnsDomainIs(host, '.google.com')
        || dnsDomainIs(host, '.google.com.hk')
        || dnsDomainIs(host, '.googleusercontent.com')
        || dnsDomainIs(host, '.blogger.com')
        || dnsDomainIs(host, '.blogspot.com')
        || dnsDomainIs(host, '.youtube.com')
        || dnsDomainIs(host, '.ytimg.com')
        || dnsDomainIs(host, 'delicious.com')
        || dnsDomainIs(host, 'lesscss.org')
        || dnsDomainIs(host, 'dropbox.com')
        || dnsDomainIs(host, 'ustream.tv')
    );
}

function isBlockedUrl(url, host) {
    return (0
        || isBlockedDnsDomain(host)
        || shExpMatch(url, '*tw.yahoo.com/*')
        || shExpMatch(url, '*tw.*.yahoo.com/*')
        || shExpMatch(url, '*twitter.com*')
        || shExpMatch(url, '*facebook.com*')
        || shExpMatch(url, '*abcdomain.com/folder/*')
        || shExpMatch(url, '*vpn.domain.com*')
    );
}

function getUnBlockProxy(host) {
    if (isInNet(LAN_IP, '10.221.131.1', '255.255.255.0')) {
        if (!(0
            || shExpMatch(host, '*.google.com*')
            || shExpMatch(host, '*twitter.com*')
            || shExpMatch(host, '*facebook.com*')
        )) {
            return PROXY_LAN;
        }
    }
    return PROXY_FREE;
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
    return isIPValid;
}

function FindProxyForURL(url, host) {

    if (url.substr(0, 4) == 'ftp:') return DIRECT;

    // Ignore Local Servers
    if (isPlainHostName(host)) return DIRECT;

    var result, isNumIP = isNumIpAddr(host), iPv4Address, hasIPv4Address = true, str = url.match(/^[^\?#]*/);
    if (str != url) {
        if (debug) log('URL modified:\n' + url + '\n' + str);
        url = str;
    }

    // local dispatcher proxy service.
    if (isLocalProxy(url, host)) { return PROXY_LOCAL; }

    // debug proxy
    if (isFiddlerMatch(url, host)) { return PROXY_DEBUG; }

    if (!isNumIP) {
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
    // Attempt to match hostname or URL to a specified shell expression.
    if (isBlockedUrl(url, host)) {
        return getUnBlockProxy(host);
    }

    return DIRECT;
}

function log(s) {
    alert(s);
}

// exports api method
exports.FindProxyForURL = FindProxyForURL;

})(typeof exports !== 'undefined' ? exports : this);
