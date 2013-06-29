# Description:
#   Sends command to CI to show boobs or boobs in fullscreen
#
# Commands:
#   hubot show big boobs - Display boobs in fullscreen mode
#   hubot friday mode on - Display boobs in default square widgets
#   hubot hide boobs - Hide boobs
#   hubot hide big boobs - Changes display from fullscreen mode to deault mode

Util = require 'util'
url = 'http://192.168.30.14:3030/api/wavegirls/show'

module.exports = (robot) ->

  send_request = (sender, message, mode) ->
    sender.http(url)
      .query(mode: mode)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          sender.send message
        else
          sender.send util.inspect res.statusCode, res.headers

  robot.respond /show big boobs/i, (msg) ->
    send_request(msg, "OH YEAH BABY! SHAKE IT!", 'fullscreen')

  robot.respond /hide big boobs/i, (msg) ->
    send_request(msg, "Take it easy boy!!!", 'friday')

  robot.respond /hide boobs/i, (msg) ->
    send_request(msg, "Party ended, see you next friday!", 'default')

  robot.respond /friday mode on/i, (msg) ->
    send_request(msg, "It's party time!!! Welcome BOOOOOOOBS!!!", 'friday')
