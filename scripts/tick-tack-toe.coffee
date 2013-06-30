# Description:
#   Allows you to play tic-tack-toe game in CI
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CI_URL - Url for CI
#
# Commands:
#   hubot tick-tack restart - Restart tick-tack-toe game on CI
#   hubot tick-tack hit <x> <y> - Hit the field with coordinates x and y
Util = require 'util'

module.exports = (robot) ->
  robot.respond /tick-tack (restart)/i, (msg) ->

    unless process.env.HUBOT_CI_URL?
      robot.logger.error "The HUBOT_CI_URL must be specified"
      return
    else
      url = 'http://' + process.env.HUBOT_CI_URL + '/api/tick-tack-toe/' + msg.match[1]

    msg.http(url)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Tick-tack #{msg.match[1]}"
        else
          msg.send util.inspect res.statusCode, res.headers

  robot.respond /tick-tack (hit) (.?) (.?)/i, (msg) ->

    unless process.env.HUBOT_CI_URL?
      robot.logger.error "The HUBOT_CI_URL must be specified"
      return
    else
      url = 'http://' + process.env.HUBOT_CI_URL + '/api/tick-tack-toe/' + msg.match[1]

    msg.http(url)
      .query(x: msg.match[2], y: msg.match[3])
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Tick-tack #{msg.match[1]} x: #{msg.match[2]}, y: #{msg.match[3]}"
        else
          msg.send util.inspect res.statusCode, res.headers
