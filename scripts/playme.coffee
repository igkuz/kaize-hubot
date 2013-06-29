# Description:
#   Play audio by query
#
# Commands:
#   hubot play me <query> - Searches Song for the query and play it
util = require 'util'

module.exports = (robot) ->
  robot.respond /(play|mp3)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    robot.http("http://www.audiopoisk.com/")
      .query({
        q: query
      })
      .get() (err, res, body) ->
        mp3 = body.match(/href="(.*mp3)"/i)
        song_url = "http://www.audiopoisk.com#{mp3[1]}"

        if !mp3
          msg.send "Song '#{query}' not found"
          return false

        backend_url = "http://192.168.30.14:3030/api/player/play"
        robot.http(backend_url)
          .query({url: song_url})
          .get() (err, res, body) ->
            status = res.statusCode
            if status == 200
              msg.send "Opening #{song_url}"
            else
              msg.send util.inspect res.statusCode, res.headers
