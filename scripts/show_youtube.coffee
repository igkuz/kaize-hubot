# Description:
#   Sends given url to CI Api to show it on
#
# Configuration:
#   HUBOT_CI_URL - Url for CI
#
# Commands:
#   hubot show video <url> - Opens the given url on CI Widget
#   hubot video stop - Stops the video and clears queue
#   hubot video next - Stops current video and shows next from the queue
#   hubot video pause - Pauses current video
util = require 'util'




module.exports = (robot) ->

  unless process.env.HUBOT_CI_URL?
    robot.logger.error "The HUBOT_CI_URL must be specified"
    return
  else
    backend_url = 'http://' + process.env.HUBOT_CI_URL + '/api/youtube/'

  send_request = (sender, url, message) -> 
    sender.http(url)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          sender.send message
        else
          robot.logger.error util.inspect res.statusCode, res.headers

  robot.respond /(show) video (.*)/i, (msg) ->
    command = msg.match[1]
    param = msg.match[2]

    msg.http(backend_url + command)
      .query({url: param})
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Opening #{param} video"
        else
          robot.logger.error util.inspect res.statusCode, res.headers

  robot.respond /video (stop|pause|next)/i, (msg) ->
    command = msg.match[1]

    send_request(msg, backend_url + command, "#{command} sended to video player")

