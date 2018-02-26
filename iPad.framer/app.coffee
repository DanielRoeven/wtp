
screen = Framer.Device.screen
Framer.Extras.Hints.disable()

activeColor = '#22CCDD'
Item_Template.opacity = 0

instantiateItemFor = (itemData) ->
	item = Item_Template.copy()
	item.opacity = 1
	
	item.childrenWithName('Name')[0].text = itemData.name
	
	timeString = itemData.hour + ':' + itemData.minutes
	if itemData.minutes == 0 then timeString += '0'
	
	item.childrenWithName('Time')[0].text = timeString
	if itemData.shareTime then item.children[1].fill = activeColor
	
	item.childrenWithName('Location')[0].text = itemData.location
	if itemData.shareLocation then item.children[0].fill = activeColor
	
	unitPos = timeToXY(itemData)
	offset = 320
	
	item.x = Align.center(+unitPos.x * offset)
	item.y = Align.center(-unitPos.y * offset)
	item.degree = timeToDegree(itemData.hour, itemData.minutes)
	item.duration = timeToDegree(itemData.durationH, itemData.durationM)
	item.states.selected =
		scale: 1.5
	
	item.states.animationOptions =
		time: .1
	
	return item

timeToXY = (item) ->
	minutes = (item.minutes % 60) / 60
	hours = (item.hour % 12) + minutes
	unitLength = hours / 12 * 2 * Math.PI
	x = Math.sin(unitLength)
	x = Math.round(x * 100) / 100
	y = Math.cos(unitLength)
	y = Math.round(y * 100) / 100
	return {x, y}

timeToDegree = (hours, minutes) ->
	myMinutes = (minutes % 60) / 60
	myHours = (hours % 12) + myMinutes
	degree = myHours / 12 * 2 * 180

# Items Data
tangibleInteractionInfo =
	name: "Tangible Interaction"
	hour: 9
	minutes: 15
	durationH: 2
	durationM: 0
	location: "Low"
	shareTime: true
	shareLocation: false

lunchInfo =
	name: "Lunch Break"
	hour: 12
	minutes: 0
	durationH: 1
	durationM: 0
	location: "High"
	shareTime: true
	shareLocation: true

informationVisualisationLectureInfo =
	name: "Info Vis Lecture"
	hour: 13
	minutes: 15
	durationH: 2
	durationM: 0
	location: " Alfa"
	shareTime: false
	shareLocation: false

informationVisualisationWorkshopInfo =
	name: "Info Vis Workshop"
	hour: 15
	minutes: 15
	durationH: 2
	durationM: 0
	location: "Jupiter 128"
	shareTime: true
	shareLocation: false

tangibleInteraction = instantiateItemFor(tangibleInteractionInfo)
lunch = instantiateItemFor(lunchInfo)
lecture = instantiateItemFor(informationVisualisationLectureInfo)
workshop = instantiateItemFor(informationVisualisationWorkshopInfo)

activities = [tangibleInteraction, lunch, lecture, workshop]

Puck.pinchable.enabled = true;
Puck.pinchable.scale = false;
Puck.pinchable.centerOrigin = false;

Puck.onPinch ->
#	hoursRot = (Puck.rotation - 1) %% 360 + 1
# 	hour = Math.floor(hoursRot/30)
# 	minutesRot = (Puck.rotation) %% 360
# 	minutes = Math.floor(minutesRot / 6)
#	print hour + ':' + minutes
	puckRotation = Puck.rotation %% 360
	for activity in activities
		if (puckRotation + 10 >= activity.degree && puckRotation + 10 < activity.degree + activity.duration)
			activity.animate('selected')
		else if (activity.states.current.name == 'selected')
			activity.animate('default')

# Create XMLHttpRequest
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
#r.send()



