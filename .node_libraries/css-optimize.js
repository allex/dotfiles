
/**
 * Css Optimiser
 *
 * Author: Allex [allex.wxn@gmail.com]
 * Last Modified: Wed Dec 21, 2011 11:28AM
 */

/*jslint continue: true, sloppy: true, indent: 4 */

function cssOptimize($css, options) {

    function cleanup($css) {
        if (!$css) { return ''; }
        return $css.replace(/\r\n/g,'');
    }

    /**
     * Optimiser the string of CSS.
     * Some inspiration are refers from the cssmin-1.0.1 package. http://minify.googlecode.com
     *
     * @param {String} $css the string of CSS to optimise.
     */
    function optimise($css) {
        if (!$css) return '';

        // normalize all whitespace strings to single spaces. easier to work with that way.
        $css = $css.replace(/[\r\n\t]+/g, ' ');
        $css = $css.replace(/\s+/g, ' ');

        // remove the spaces before the things that should not have spaces before them.
        // but, be careful not to turn "p :link {...}" into "p:link{...}"
        // swap out any pseudo-class colons with the token, and then swap back.
        $css = $css.replace(/(^|\})(([^{:])+:)+([^{]*\{)/g, function($0) {
            return $0.replace(/:/g, '___PSEUDOCLASSCOLON___');
        });
        $css = $css.replace(/\s+([!{};:>+\],])/g, '$1');
        $css = $css.replace(/___PSEUDOCLASSCOLON___/g, ':');

        // remove the spaces after the things that should not have spaces after them
        $css = $css.replace(/([!{}:;>+\(\[,\/])\s+/g, '$1');

        // add the semicolon where it's missing.
        $css = $css.replace(/([^;{}])\}/g, '$1;}');

        // replace 0(px,em,%) with 0.
        $css = $css.replace(/([\s:])(0)(px|em|%|in|cm|mm|pc|pt|ex)/g, '$1$2');

        // replace 0 0 0; with 0.
        $css = $css.replace(/:0 (0 ){0,2}0;/g, ':0;');

        // replace background-position:0; with background-position:0 0;
        $css = $css.replace(/background-position:0;/g, 'background-position:0 0;');

        // replace 0.12em with .12em
        $css = $css.replace(/(:|\s)0+\.(\d+)/g, '$1.$2');

        // minimize hex colors
        // http://minify.googlecode.com/svn/trunk/min/lib/Minify/CSS/Compressor.php
        $css = $css.replace(/([^=]\s?)\s*#([a-f\d])\2([a-f\d])\3([a-f\d])\4([\s;}])/ig, function($0,$1,$2,$3,$4,$5){return $1+'#'+($2+$3+$4).toLowerCase()+$5;});
        // prevent triggering IE6 bug: http://www.crankygeek.com/ie6pebug/
        $css = $css.replace(/:first-l(etter|ine)\{/g, ':first-l$1 {');

        // Replace multiple semi-colons in a row by a single one
        $css = $css.replace(/;+/g, ';');

        $css = $css.replace(/@(?:import|charset) [^;]+;/, function($0) { return $0 + "\n"; });

        return $css.replace(/^\s\s*|\s\s*$/, '');
    }

    // Format the strings of CSS.
    var s = optimise(cleanup($css)), mode = isNaN(options.mode) ? 1 : options.mode;
    switch (mode) {
        case 1:
        case 2:
            s = s.replace(/(\}|\*\/)/g,'$1\n');
            if (mode === 2) s = s.replace(/([;{])(?=[^}]+?)/g,'$1\n\t').replace(/\}/g,'\n}');
            break;
        case 0:
        default:
            break;
    }
    return s;
}

if (typeof exports !== "undefined") {
    exports.cssOptimize = cssOptimize;
}
