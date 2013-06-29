# Description:
#   Play audio by query
#
# Commands:
#   hubot play me <query> - Searches Song for the query and play it
#   hubot player stop - Stop the player
#   hubot player pause - Pause the player
#   hubot player resume - Resume the player
#   hubot player volume <query> - Set volume from 0 to 1 (ex. 0.75)
util = require 'util'

module.exports = (robot) ->
  robot.follow_http = require('follow-redirects').http

  unless process.env.HUBOT_CI_URL?
    robot.logger.error "The HUBOT_CI_URL must be specified"
    return
  else
    global.backend_url = 'http://' + process.env.HUBOT_CI_URL + '/api'

  find_track_in_trackflow = (query, msg) ->
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
              return null

            body = JSON.parse(body)
            song_url = body["url"]
            return song_url

  find_track_in_poiskm = (query, msg, callback) ->
    robot.http("http://poiskm.com/")
      .query(
        q: query
        c: 'search'
      )
      .get() (err, res, body) ->
        tracks = body.match(/([^"]+download=download.mp3+)/ig)

        test_poiskm_tracks(tracks, msg, 0, callback)


  test_poiskm_tracks = (tracks, msg, position, callback) ->
    msg.send "Test #{position}"

    if !tracks || !tracks[position]
      msg.send "Song not found"
      return

    track = tracks[position]
    song_url = track.replace(/download=download/, 'download')
    song_url = song_url.replace(new RegExp(song_url[6], 'g'), '/')

    msg.send song_url

    test_url = (song_url, msg, callback) ->
      robot.http(song_url).head() (err, res, body) ->
        if res.headers && res.headers.location
          test_url(res.headers.location, msg, callback)
          return

        if res.statusCode != 200
          msg.send "Song not found, but I'm continue search"
          test_poiskm_tracks(tracks, msg, position+1, callback)
        else
          callback(song_url, msg)
    test_url(song_url, msg, callback)

  play = (query, msg) ->
    song_url = find_track_in_poiskm(query, msg, play_by_url)

    #if !song_url
      #song_url = find_track_in_trackflow(query, msg, play_by_url)


  play_by_url = (song_url, msg) ->
    if !song_url
      msg.send "Song not found"
      return

    robot.http(global.backend_url + "/player/play")
      .query({url: song_url})
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Opening #{song_url}"
        else
          msg.send util.inspect res.statusCode, res.headers

  stop = (msg) ->
    robot.http(global.backend_url + "/player/stop")
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Stop player"
        else
          msg.send util.inspect res.statusCode, res.headers

  volume = (value, msg) ->
    robot.http(global.backend_url + "/player/volume")
      .query({value: value})
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Volume set to #{value}"
        else
          msg.send util.inspect res.statusCode, res.headers

  pause = (msg) ->
    robot.http(global.backend_url + "/player/pause")
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Player set to pause"
        else
          msg.send util.inspect res.statusCode, res.headers

  resume = (msg) ->
    robot.http(global.backend_url + "/player/resume")
      .get() (err, res, body) ->
        status = res.statusCode
        if status == 200
          msg.send "Player resume play"
        else
          msg.send util.inspect res.statusCode, res.headers


  robot.respond /play me (.*)/i, (msg) ->
    query = msg.match[1]
    play query, msg

  robot.respond /player stop/i, (msg) ->
    stop msg

  robot.respond /player volume (.*)/i, (msg) ->
    value = msg.match[1]
    volume value, msg

  robot.respond /player pause/i, (msg) ->
    pause msg

  robot.respond /player resume/i, (msg) ->
    resume msg
