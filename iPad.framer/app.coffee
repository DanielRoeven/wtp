
screen = Framer.Device.screen
Framer.Extras.Hints.disable()

inactiveColor = '#CFCFCF'
inactiveBorderColor = '#4F4F4F'
activeColor = '#AFD3E3'
activeBorderColor = '#3497C1'
activeTextColor = '#171717'
Item_Template.opacity = 0

instantiateItemFor = (itemData) ->
	item = Item_Template.copy()
	item.opacity = 1
	
	item.childrenWithName('NameText')[0].text = itemData.name
	
	timeString = itemData.hour + ':' + itemData.minutes
	if itemData.minutes == 0 then timeString += '0'
	
	item.childrenWithName('TimeText')[0].text = timeString
	item.children[1].states.animationOptions =
		time: 10.15
	item.children[1].states.sharing =
		fill: activeColor
	if itemData.shareTime
		item.children[1].animate('sharing')
	
	item.childrenWithName('LocationText')[0].text = itemData.location
	item.children[0].states.animationOptions =
		time: .15
	item.children[0].states.sharing =
		fill: activeColor
	if itemData.shareLocation
		item.children[0].animate('sharing')
	
	unitPos = timeToXY(itemData)
	offset = 320
	
	item.x = Align.center(+unitPos.x * offset)
	item.y = Align.center(-unitPos.y * offset)
	item.degree = timeToDegree(itemData.hour, itemData.minutes)
	item.duration = timeToDegree(itemData.durationH, itemData.durationM)
	
	item.states.default =
		scale: 0.75
	item.stateSwitch('default');
	
	item.states.selected =
		scale: 1

	item.states.animationOptions =
		time: .15
	
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
	durationH: 1
	durationM: 0
	location: "Low"
	shareTime: true
	shareLocation: false

someEvent =
	name: "someEvent"
	hour: 10
	minutes: 15
	durationH: 2
	durationM: 0
	location: "Low"
	shareTime: false
	shareLocation: false

lunchInfo =
	name: "Lunch Break"
	hour: 12
	minutes: 0
	durationH: 1
	durationM: 0
	location: "High"
	shareTime: false
	shareLocation: false

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
	shareTime: false
	shareLocation: false

anotherOne =
	name: "anotherOne"
	hour: 17
	minutes: 15
	durationH: 2
	durationM: 0
	location: "Someplace"
	shareTime: false
	shareLocation: false

tangibleInteraction = instantiateItemFor(tangibleInteractionInfo)
someEvent = instantiateItemFor(someEvent)
lunch = instantiateItemFor(lunchInfo)
lecture = instantiateItemFor(informationVisualisationLectureInfo)
workshop = instantiateItemFor(informationVisualisationWorkshopInfo)
anotherOne = instantiateItemFor(anotherOne)

activities = [tangibleInteraction, someEvent, lunch, lecture, workshop, anotherOne]

Puck.pinchable.enabled = true;
Puck.pinchable.scale = false;
Puck.pinchable.centerOrigin = false;
Puck.pinchable.rotateIncrements = .5;

Puck.onRotate ->
	rotateToSelect()

selectedActivity = null
rotateToSelect = Utils.throttle .1, ->
		selected = false
		deselected = false
		puckRotation = Puck.rotation %% 360
		for activity in activities
			inBounds = (puckRotation + 10 >= activity.degree) &&  (puckRotation + 10 < activity.degree + activity.duration)
			state = activity.states.current.name
			if (state == 'selected' && !inBounds)
				activity.animate('default')
				deselected = true
			else if (state == 'default' && inBounds)
				activity.animate('selected')
				selectedActivity = activity
				selected = true
		if (deselected && !selected)
			selectedActivity = null

Frame.onTouchStart (e) ->
	if (e.touches.length > 2 && selectedActivity)
		if (!selectedActivity.shareTime)
			selectedActivity.shareTime = true
		else if (!selectedActivity.shareLocation)
			selectedActivity.shareLocation = true
		else
			selectedActivity.shareTime = false
			selectedActivity.shareLocation = false
		redrawItem(selectedActivity)

redrawItem = (activity) ->
	if activity.shareTime
		activity.children[1].fill = activeColor
		activity.children[1].borderColor = activeBorderColor
		activity.childrenWithName('NameText').color = activeTextColor
		activity.childrenWithName('TimeText').color = activeTextColor
	else
		activity.children[1].fill = inactiveColor
		activity.children[1].borderColor = inactiveBorderColor
	if activity.shareLocation
		activity.children[0].fill = activeColor
		activity.children[0].borderColor = activeBorderColor
	else
		activity.children[0].fill = inactiveColor
		activity.children[0].borderColor = inactiveBorderColor
		
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



