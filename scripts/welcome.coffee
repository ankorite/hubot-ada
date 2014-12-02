# Description:
#   Send a welcome message to first time users
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   Christian Vermeulen
#     info@christianvermeulen.net

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.welcomeUsers ||= []
    robot.brain.data.welcomeMsg ||= "Welcome to the Slack team! I am your personal chatbot here to make your life easier. For more information on my commands say '[my name] help' in chat."

  robot.respond /welcome (.*)$/i, (msg) ->
    if msg.message.user.name in robot.brain.data.admins
      robot.brain.data.welcomeMsg = msg.match[1]
#      robot.brain.data.welcomeUsers = []
      msg.send "I will notify everybody of this new message!"
    else
      msg.send "You are so naughty! Ask one of the admins to change this."

  robot.hear /./i, (msg) ->
    welcomeUsers = robot.brain.data.welcomeUsers
    if msg.message.user.name not in welcomeUsers
      welcomeUsers.push(msg.message.user.name)
      msg.send "Hey "+msg.message.user.name+", "+robot.brain.data.welcomeMsg

  robot.respond /welcometest$/i, (msg) ->
    msg.send "Hey "+msg.message.user.name+", "+robot.brain.data.welcomeMsg
