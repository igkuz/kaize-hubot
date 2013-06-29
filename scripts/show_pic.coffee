# Description:
#   Sends command to CI to show picture from given url
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CI_URL - Url for CI
#
# Commands:
#   hubot show pic <url> - Display picture from given url

Util = require 'util'

module.exports = (robot) ->
  robot.respond /show pic (.*)/i, (msg) ->

    unless process.env.HUBOT_CI_URL?
      robot.logger.error "The HUBOT_CI_URL must be specified"
      return
    else
      url = 'http://' + process.env.HUBOT_CI_URL + '/api/pic/show'
      msg.send Util.inspect url

    msg.http(url)
      .query({url: msg.match[1]})
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Opening picture from #{msg.match[1]}"
        else
          msg.send util.inspect res.statusCode, res.headers
