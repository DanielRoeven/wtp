
screen = Framer.Device.screen
Framer.Extras.Hints.disable()

fragments = {
	33: [Segment2, Segment3], 
	42: [Segment4, Segment5],
	51: [Segment6, Segment7],
	60: [Segment8, Segment9],
	69: [Segment10]
	};

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


# Person Dalan 
dalan =
	standupMeeting =
		name: "Stand up meeting"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 101"
		shareTime: false
		shareLocation: false

	clientMeeting =
		name: "Meeting with Client"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Office 201"
		shareTime: false
		shareLocation: false

	lunchInfo =
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: false
		shareLocation: false

	presentationEvent =
		name: "Presentation Event"
		hour: 14
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Big hall"
		shareTime: false
		shareLocation: false

	brainstormingWorkshop =
		name: "Brainstorming Workshop"
		hour: 16
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 101"
		shareTime: false
		shareLocation: false


# Person Pol
pol = 
	halftimeMeeting =
		name: "Half time meeting"
		hour: 9
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Office 134"
		shareTime: true
		shareLocation: false

	interview =
		name: "Skype Interview"
		hour: 11
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 12"
		shareTime: true
		shareLocation: false

	lunchtime =
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: false
		shareLocation: false

	presentationEvent =
		name: "Presentation Event"
		hour: 14
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Big hall"
		shareTime: false
		shareLocation: false

	researchtime=
		name: "Research time"
		hour: 15
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Office 40"
		shareTime: false
		shareLocation: false


# Person Maitas
maitas = 
	developing =
		name: "App Development"
		hour: 8
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 17"
		shareTime: false
		shareLocation: false

	clientMeeting =
		name: "Meeting with Client"
		hour: 11
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 101"
		shareTime: false
		shareLocation: false

	lunchtime =
		name: "Lunch Break"
		hour: 13
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Kitchen Area"
		shareTime: false
		shareLocation: false



# Person Matalda
matalda = 
	scrummeeting =
		name: "Scrum Meeting"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 55"
		shareTime: false
		shareLocation: false

	usertesting =
		name: "User testing"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "At Client's Office"
		shareTime: false
		shareLocation: false

	lunchtime =
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Kitchen Area"
		shareTime: false
		shareLocation: false

	clientMeeting =
		name: "Meeting with Client"
		hour: 13
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 201"
		shareTime: false
		shareLocation: false

	interview =
		name: "Skype Interview"
		hour: 15
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Office 12"
		shareTime: true
		shareLocation: false	


# Person Ala
ala = 
	standupMeeting =
		name: "Standup Meetin"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 201"
		shareTime: false
		shareLocation: false

	presentationEvent =
		name: "Presentation Even"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Big Hall"
		shareTime: true
		shareLocation: false	

	lunchtime =
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: false
		shareLocation: false
	
	brainstormingWorkshop =
		name: "Brainstorming Workshop"
		hour: 14
		minutes: 0
		durationH: 3
		durationM: 0
		location: "Room 101"
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
			redrawSegments(fragments[selectedActivity.id], "1")
		else if (!selectedActivity.shareLocation)
			selectedActivity.shareLocation = true
			redrawSegments(fragments[selectedActivity.id], "2")
		else
			selectedActivity.shareTime = false
			selectedActivity.shareLocation = false
			redrawSegments(fragments[selectedActivity.id], "0")
		redrawItem(selectedActivity)

redrawSegments = (segments, state) ->
	len = Object.keys(segments).length
	if (state == "1")
		for i in [0...len]
			segments[i].fill = activeColor
	else if (state == "2")
		for i in [0...len]
			segments[i].fill = activeBorderColor
	else
		for i in [0...len]
			segments[i].fill = inactiveColor

redrawItem = (activity) ->
	if activity.shareTime
		activity.children[1].fill = activeColor
		activity.children[1].borderColor = activeBorderColor
		activity.childrenWithName('NameText').color = activeTextColor
		activity.childrenWithName('TimeText').color = activeTextColor
	else
		activity.children[1].fill = inactiveColor
		activity.children[1].borderColor = inactiveBorderColor
		activity.childrenWithName('NameText').color = inactiveBorderColor
		activity.childrenWithName('TimeText').color = inactiveBorderColor
	if activity.shareLocation
		activity.children[0].fill = activeColor
		activity.children[0].borderColor = activeBorderColor
		activity.childrenWithName('LocationText').color = activeTextColor
	else
		activity.children[0].fill = inactiveColor
		activity.children[0].borderColor = inactiveBorderColor
		activity.childrenWithName('LocationText').color = i
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