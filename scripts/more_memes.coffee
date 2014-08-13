# Description:
#   Get a meme from http://memecaptain.com/
#
# Dependencies:
#   None
#
# Commands:
#   hubot <top text> WOLF <bottom text> - Insanity Wolf
#   hubot <top text> GRUMPY CAT <bottom text> - Grumpy Cat
#
# Author:
#   bobanj

module.exports = (robot) ->
  robot.respond /(.*)WOLF(.*)/i, (msg) ->
    memeGenerator msg, 'http://v1.memecaptain.com/insanity_wolf.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

  robot.respond /(.*)GRUMPY(.*)/i, (msg) ->
    memeGenerator msg, 'http://memecaptain.com/src_images/_k6JVg.jpg', msg.match[1], msg.match[2], (url) ->
      msg.send url

memeGenerator = (msg, imageName, text1, text2, callback) ->
  imageUrl = imageName

  processResult = (err, res, body) ->
    return msg.send err if err
    if res.statusCode == 301
      msg.http(res.headers.location).get() processResult
      return
    if res.statusCode > 300
      msg.reply "Sorry, I couldn't generate that meme. Unexpected status from memecaption.com: #{res.statusCode}"
      return
    try
      result = JSON.parse(body)
    catch error
      msg.reply "Sorry, I couldn't generate that meme. Unexpected response from memecaptain.com: #{body}"
    if result? and result['imageUrl']?
      callback result['imageUrl']
    else
      msg.reply "Sorry, I couldn't generate that meme."

  msg.http("http://memecaptain.com/g")
  .query(
    u: imageUrl,
    t1: text1,
    t2: text2
  ).get() processResult
