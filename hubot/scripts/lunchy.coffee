# Description
#   Lunchy picks spots so you don't have to.
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   lunchy add spot <expression>- Adds a spot to lunchy
#   lunchy remove spot <expression>- removes a spot to lunchy
#   lunchy edit spot <old_name>, <new_name>- renames a spot in lunchy
#   lunchy list spots - lists all spots within lunchy
#   lunchy pick spot - tells lunchy to pick a spot
#   lunchy I like <spot_name>- informs lunchy of your preferred spot
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   kwstannard
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
      .http("http://localhost:3000/add_spot")
      .query
        name: name
      .post() (err, res, body) ->
        if res.statusCode is 201
          msg.send "Lunchy has approved #{msg.message.user.name}'s request to add #{name} to it's enourmous database"
        else
          msg.send (JSON.parse body).description

  robot.respond /remove spot (.*)/i, (msg) ->
    name = msg.match[1]
    msg
      .http("http://localhost:3000/remove_spot")
      .query
        name: name
      .post() (err, res, body) ->
        if res.statusCode is 200
          msg.send "Lunchy has allowed #{msg.message.user.name} to remove #{name} from it's superior memory banks"
        else
          msg.send (JSON.parse body).description

  robot.respond /edit spot ([^,]*), (.*)/i, (msg) ->
    name_old = msg.match[1]
    name_new = msg.match[2]
    msg
      .http("http://localhost:3000/edit_spot")
      .query
        name_old: name_old
        name_new: name_new
      .post() (err, res, body) ->
        if res.statusCode is 200
          msg.send "Lunchy has easily changed the name of #{name_old} to #{name_new}"
        else
          msg.send (JSON.parse body).description

  robot.respond /list spots/i, (msg) ->
    msg
      .http("http://localhost:3000/list_spots")
      .get() (err, res, body) ->
        msg.send body

  robot.respond /pick spot/i, (msg) ->
    pick_spot(null)

  robot.respond /I like (.*)/i, (msg) ->
    user_name = msg.message.user.name
    spot_name = msg.match[1]
    msg
      .http("http://localhost:3000/set_favorite")
      .query
        user_name: user_name
        spot_name: spot_name
      .post() (err, res, body) ->
        if res.statusCode is 200
          msg.send "Lunchy has noted that #{user_name} likes #{spot_name} in it's mighty computer brain"
        else
          msg.send (JSON.parse body).description

  pick_spot = (customText) ->
    user_names = ""
    for own key, user of robot.users()
      user_names += "#{user.name},"
    console.log user_names
    robot
      .http("http://localhost:3000/pick_spot")
      .query
        user_names: user_names
      .get() (err, res, body) ->
        selection = JSON.parse body
        date = selection.last_went
        response = ""

        response += ":pizza: :pizza: :pizza: Lunchy has selected #{selection.name} for the pathetic humans.\n"
        response += ":pizza: :pizza: :pizza: Lunchy last told the meatbags to eat here on #{date}."

        robot.messageRoom null, customText if customText
        robot.messageRoom null, response

