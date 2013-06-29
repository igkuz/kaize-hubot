# Description:
#   Sends given url to CI Api to show it on
#
# Commands:
#   hubot video show <url> - Opens the given url on CI Widget
util = require 'util'


module.exports = (robot) ->
  robot.respond /video show (.*)/i, (msg) ->
    param = msg.match[1]
    url = 'http://192.168.30.14:3030/api/youtube/show'

    msg.http(url)
      .query({url: param})
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Opening #{param} video"
        else
          msg.send util.inspect res.statusCode, res.headers
