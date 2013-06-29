# Description:
#   Sends command to CI to show picture from given url
#
# Commands:
#   hubot show pic <url> - Display picture from given url

Util = require 'util'
url = 'http://192.168.30.14:3030/api/pic/show'

module.exports = (robot) ->
  robot.respond /show pic (.*)/i, (msg) ->
    msg.http(url)
      .query(url: msg.match[1])
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Opening picture from #{msg.match[1]}"
        else
          msg.send util.inspect res.statusCode, res.headers
