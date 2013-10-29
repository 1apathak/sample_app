# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



# create youtube player
onYouTubePlayerAPIReady = ->
  player = new YT.Player("player",
    height: "390"
    width: "640"
    videoId: "0Bmhjf0rKe8"
    events:
      onReady: onPlayerReady
      onStateChange: onPlayerStateChange
  )

# autoplay video
onPlayerReady = (event) ->
  event.target.playVideo()

# when video ends
onPlayerStateChange = (event) ->
  alert "done"  if event.data is 0
player = undefined

