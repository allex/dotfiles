/* vim: set ft=javascript tw=75 sw=4: */
/*!-------------------------------------------------------------------

 Author: Allex (allex.wxn@gmail.com)
 Last Modified: Wed May 09, 2012 10:16AM

 see also:
 http://findproxyforurl.com/pac_file_examples.html
 http://findproxyforurl.com/pac_functions_explained.html

--------------------------------------------------------------------*/
<?php

function checkproxy($server, $port, $deep = TRUE) {
    $verbinding = @fsockopen($server, $port, $errno, $errstr, 2);
    if ($verbinding) {
        fclose($verbinding);
        if ($deep) {
            $url = "http://$server:$port";
            list($status) = @get_headers($url);
            if (!$status || strpos($status, '404') !== FALSE) {
                // URL is 404ing
                return false;
            }
        }
        return true;
    }
    return false;
}

header('Content-Type: text/javascript; charset=utf-8');

$ip = exec(getenv('bin').'/ip');
$lan_proxy_ip = '192.168.100.221';

if (!$ip) {
    $ip = '127.0.0.1';
}

$dp = 'DIRECT';
$fp = 'DIRECT';

// goagent proxy
if (checkproxy('proxy', 8087, FALSE)) {
    $fp = "PROXY proxy:8087";
} else {
    // free gate
    if (checkproxy('proxy', 8580)) {
        $fp = "PROXY proxy:8580";
    } else {
        // lan proxy
        if (checkproxy($lan_proxy_ip, '80')) {
            $fp = "PROXY $lan_proxy_ip:80";
        }
    }
}

if (checkproxy('proxy', 8888)) {
    $dp = "PROXY proxy:8888";
}

echo "\n// Timestamp: " . date("F j, Y, g:i a") . "\n";
?>

(function(exports) {

var LAN_IP       = '<?=$ip?>';
var LAN_PROXY_IP = '192.168.100.221';
var DIRECT       = 'DIRECT';
var PROXY_LAN    = 'PROXY ' + LAN_PROXY_IP + ':80';
var PROXY_FREE   = '<?=$fp?>';
var PROXY_DEBUG  = '<?=$dp?>';

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

function isDebugMatch(url) {
    return (0
        || shExpMatch(url, '*.127.net/*')
        || shExpMatch(url, '*.163.com/*')
        || shExpMatch(url, '*m.sinaimg.cn/*')
        || shExpMatch(url, '*.sina.com.cn/*')
        || shExpMatch(url, '*.sinaimg.cn/*')
        || shExpMatch(url, '*.weibo.com/*')
    );
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

    // debug proxy
    if (isDebugMatch(url)) {
        return PROXY_DEBUG;
    }

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

})(this);
