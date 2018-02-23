# HTTPRequest = require "HTTPRequest"

screen = Framer.Device.screen
Framer.Extras.Hints.disable()

# Item_Template.opacity = 0
Item_Template.childrenWithName('Time')[0].text = '1400'

createItem = (itemData) ->
	item = Item_Template.copy()

timeToXY = (item) ->
	minutes = (item.minute % 60) / 60
	hours = (item.hour % 12) + minutes
	unitLength = hours / 12 * 2 * Math.PI
	x = Math.sin(unitLength)
	x = Math.round(x * 100) / 100
	y = Math.cos(unitLength)
	y = Math.round(y * 100) / 100

tangibleInteraction =
	name: "Tangible Interaction"
	hour: 9
	minute: 15
	location: "Low"

timeToXY(tangibleInteraction);


callback = (data) ->
	print data

r = new XMLHttpRequest
r.open 'GET', 'http://42.42.42.42', true
r.setRequestHeader('Content-type', 'text/plain')
r.onreadystatechange = ->
	if (r.readyState == XMLHttpRequest.DONE)
		if (r.status >= 200 && r.status <= 206)
			data = r.response
			callback(data)
		else
			print r.status
r.send()



