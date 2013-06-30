# Description:
#   Sends command to CI to show or hide presentations from slideshare
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CI_URL - Url for CI
#
# Commands:
#   hubot slideshare show - Display slideshare presentation
#   hubot slideshare hide - Hide slideshare presentation
Util = require 'util'

module.exports = (robot) ->
  robot.respond /slideshare (show|hide)/i, (msg) ->

    unless process.env.HUBOT_CI_URL?
      robot.logger.error "The HUBOT_CI_URL must be specified"
      return
    else
      url = 'http://' + process.env.HUBOT_CI_URL + '/api/slideshare/' + msg.match[1]

    msg.http(url)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Slideshare #{msg.match[1]} presentation"
        else
          msg.send util.inspect res.statusCode, res.headers
