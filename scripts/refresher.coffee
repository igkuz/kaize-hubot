# Description:
#   Refreshes CI
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CI_URL - Url for CI
#
# Commands:
#   hubot refresh ci - Refreshes CI

Util = require 'util'

module.exports = (robot) ->
  robot.respond /refresh ci/i, (msg) ->

    unless process.env.HUBOT_CI_URL?
      robot.logger.error "The HUBOT_CI_URL must be specified"
      return
    else
      url = 'http://' + process.env.HUBOT_CI_URL + '/api/refresher/refresh'
      msg.send Util.inspect url

    msg.http(url)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Refreshing CI"
        else
          robot.logger.debug util.inspect res.statusCode, res.headers
