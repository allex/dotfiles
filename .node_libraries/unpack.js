/**
 * Unpack the codes which packed by a specific algorithm with eval();
 *
 * @author Allex Wang (allex.wxn@gmail.com)
 */

(function (require, exports, module) {
  'use strict'

  var stringTokens = { '"': 1, '\'': 1 },
    tokens = {
      '{': '}',
      '[': ']',
      '(': ')',
      '"': '"',
      "'": "'"
    },
    closeTokens = reversePairs(tokens)

  exports.unpack = unpack

  function unpack (text) {
    var m, offset = 0, j = -1, buffer = [] // eslint-disable-line no-unused-vars
    while (text) {
      if (m = match(text)) {
        offset = m.end
        buffer[++j] = text.substring(0, m.index)
        buffer[++j] = getEvalString(m.text)
        text = text.substring(m.end)
      } else {
        buffer[++j] = text
        text = ''
      }
    }
    return buffer.join('')
  }

  function reversePairs (tokens) {
    var o = {}
    for (var k in tokens) {
      if (tokens.hasOwnProperty(k)) o[tokens[k]] = k
    }
    return o
  }

  function end (arr) {
    return arr[arr.length - 1]
  }

  /**
   * Find the specific balance token index.
   *
   * @private
   * @author Allex Wang (allex.wxn@gmail.com)
   *
   * MIT Licensed
   */
  function findBalanceTokenIndex (str, start, token) {
    if (!token || !tokens[token]) {
      throw Error('The target token for balance is not valid.')
    }

    var c, i = start || 0, l = str.length, stack = [], top, matched
    if (i > l) {
      return -1
    }

    while (i < l) {
      c = str[i++]

      // push opening tokens to the stack (for " and ' only if there is no " or ' opened yet)
      if (tokens[c] && (!stringTokens[c] || end(stack) !== c)) {
        stack.push(c)

        // closing tokens have to be matched up with the stack elements
      } else if (closeTokens[c]) {
        matched = false
        while (top = stack.pop()) {
          // stack has matching opening for current closing
          if (top === closeTokens[c]) {
            matched = true
            break
          }
        }
        if (matched && top === token && stack.length === 0) {
          return i
        }
      }
    }

    return -1
  }

  function getEvalString (s) {
    return (0, eval)('String(' + s + ')') // eslint-disable-line no-eval
  }

  function match (str) {
    var start = str.indexOf('eval(function('), end = -1, text
    if (start !== -1) {
      end = findBalanceTokenIndex(str, start + 4, '(')
      if (start < end) {
        text = str.substring(start + 4, end)
        return { index: start, end: end, text: text }
      }
    }
    return null
  }

}(require, exports, module, this))
