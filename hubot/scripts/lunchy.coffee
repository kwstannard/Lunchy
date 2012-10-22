# Description
#   derps
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   <lunchy> <command>, <expression>- <runs a lunchy command>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <kwstannard>
module.exports = (robot) ->

  cronJob = require('cron').CronJob
  random_lunch_time = new cronJob(
    '0 15 11 * * 1-5',
    -> robot.send pick_spot("/play bueller"),
    null,
    true,
    null
  )

  robot.respond /add spot (.*)/i, (msg) ->
    name = msg.match[1]
    msg
      .http("http://localhost:3000/add")
      .query
        name: name
      .post() (err, res, body) ->
        if res.statusCode is 201
          msg.send "#{msg.message.user.name} added #{name} successfully"
        else
          msg.send (JSON.parse body).description

  robot.respond /remove spot (.*)/i, (msg) ->
    name = msg.match[1]
    msg
      .http("http://localhost:3000/remove")
      .query
        name: name
      .post() (err, res, body) ->
        if res.statusCode is 200
          msg.send "#{msg.message.user.name} removed #{name} successfully"

  robot.respond /edit spot ([^,]*), (.*)/i, (msg) ->
    name_old = msg.match[1]
    name_new = msg.match[2]
    msg
      .http("http://localhost:3000/edit")
      .query
        name_old: name_old
        name_new: name_new
      .post() (err, res, body) ->
        if res.statusCode is 200
          msg.send "#{name_old} editted successfully to #{name_new}"

  robot.respond /list spots/i, (msg) ->
    msg
      .http("http://localhost:3000/list_spots")
      .get() (err, res, body) ->
        msg.send body

  robot.respond /derp/i, (msg) ->
    response = ""
    for own key, user of robot.users()
      response += "#{user.id} : #{user.name} | "
    msg.send response

  robot.respond /pick spot/i, (msg) ->
    pick_spot(null)

  pick_spot = (customText) ->
    robot
      .http("http://localhost:3000/pick_spot")
      .get() (err, res, body) ->
        selection = JSON.parse body
        date = selection.last_went
        response = ""

        response += ":pizza: :pizza: :pizza: Lunchy has selected #{selection.name} for the pathetic humans.\n"
        response += ":pizza: :pizza: :pizza: Lunchy last told the meatbags to eat here on #{date}."

        robot.messageRoom null, customText if customText
        robot.messageRoom null, response

