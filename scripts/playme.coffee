# Description:
#   Play audio by query
#
# Commands:
#   hubot play me <query> - Searches Song for the query and play it
util = require 'util'

module.exports = (robot) ->

  play = (query, msg) ->
    robot.http("http://tracksflow.com/2.0/api/tracks")
      .query(
        for: query
        in: 'search'
        pageNum: 0
        pageSize: 20
      )
      .get() (err, res, body) ->
        audios = JSON.parse(body)
        track = audios[0]

        url = "http://tracksflow.com/2.0/api/search/source/" + track['artistName'] + "/" + track['trackName']

        robot.http(url)
          .get() (err, res, body) ->
            status = res.statusCode
            if status != 200
              msg.send "Song not found"
              return

            body = JSON.parse(body)
            song_url = body["url"]

            backend_url = "http://192.168.30.197:3030/api/player/play"
            robot.http(backend_url)
              .query({url: song_url})
              .get() (err, res, body) ->
                status = res.statusCode
                if status == 200
                  msg.send "Opening #{song_url}"
                else
                  msg.send util.inspect res.statusCode, res.headers

  stop = (msg) ->
    backend_url = "http://192.168.30.197:3030/api/player/stop"
    robot.http(backend_url)
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Stop player"
        else
          msg.send util.inspect res.statusCode, res.headers


  robot.respond /play me (.*)/i, (msg) ->
    query = msg.match[1]
    play query, msg

  robot.respond /player stop/i, (msg) ->
    stop msg
