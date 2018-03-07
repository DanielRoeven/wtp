
screen = Framer.Device.screen
Framer.Extras.Hints.disable()

inactiveColor = '#D1D1D1'
inactiveBorderColor = '#4F4F4F'
activeTimeColor = '#B8D8E5'
activePlaceColor = '#379FCC'
activeTimeBorderColor = '#3497C1'
activePlaceBorderColor = '#0374A3'
activeTextColor = '171717'
allActivityStatus = 'shareNothing'
Item_Template.opacity = 0
Segment_Template.opacity = 0
isAuthorised = false

Frame.states.hidden =
	opacity: 0
Frame.animationOptions =
	time: 1

instantiateSegment = (startHour) ->
	segment = Segment_Template.copy()
	segment.opacity = 1
	segment.parent = Frame
	index = (startHour) %% 12
	segment.rotation += index * 30
	
	segment.children[0].animationOptions =
		time: .15
	
	segment.children[0].states.shareNothing =
		fill: inactiveColor
	segment.children[0].states.shareTime =
		fill: activeTimeColor
	segment.children[0].states.shareLocation =
		fill: activePlaceColor
	segment.children[0].stateSwitch('shareNothing')
	
	return segment
# Create Segments Object
segments =
	8: instantiateSegment(8)
	9: instantiateSegment(9)
	10: instantiateSegment(10)
	11: instantiateSegment(11)
	12: instantiateSegment(12)
	13: instantiateSegment(13)
	14: instantiateSegment(14)
	15: instantiateSegment(15)
	16: instantiateSegment(16)
clearSegments = ->
	redrawSegments(8, 9, 'shareNothing')

instantiateItemFor = (itemData, checkIn) ->
	item = Item_Template.copy()
	item.opacity = 1
	item.hour = itemData.hour
	item.durationH = itemData.durationH
	
	item.childrenWithName('NameText')[0].text = itemData.name
		
	timeString = itemData.hour + ':' + itemData.minutes
	if itemData.minutes == 0 then timeString += '0'
	
	item.childrenWithName('TimeText')[0].text = timeString
	item.children[1].states.animationOptions =
		time: .15
	item.children[1].states.sharing =
		fill: activeTimeColor
	if itemData.shareTime
		item.children[1].animate('sharing')
	
	item.childrenWithName('LocationText')[0].text = itemData.location
	item.children[0].states.animationOptions =
		time: .15
	item.children[0].states.sharing =
		fill: activePlaceColor
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
	
	if (!checkIn && !itemData.shareLocation)
		item.childrenWithName('LocationText')[0].text = ""
	if (!checkIn && !itemData.shareTime)
		item.opacity = 0	
	
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
	standupMeeting: 
		name: "Standup Meeting"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 101"
		shareTime: true
		shareLocation: false
	clientMeeting:
		name: "Meeting with Client"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Office 201"
		shareTime: false
		shareLocation: false
	lunchInfo:
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: true
		shareLocation: true
	presentationEvent:
		name: "Presentation Event"
		hour: 14
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Big hall"
		shareTime: false
		shareLocation: false
	brainstormingWorkshop:
		name: "Brainstorming"
		hour: 16
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 101"
		shareTime: true
		shareLocation: false
# Person Pol
pol = 
	halftimeMeeting:
		name: "Half time meeting"
		hour: 9
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Office 134"
		shareTime: true
		shareLocation: false
	interview:
		name: "Skype Interview"
		hour: 11
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 12"
		shareTime: true
		shareLocation: false
	lunchtime:
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: false
		shareLocation: false
	presentationEvent:
		name: "Presentation Event"
		hour: 14
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Big hall"
		shareTime: true
		shareLocation: true
	researchtime:
		name: "Research time"
		hour: 15
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Office 40"
		shareTime: true
		shareLocation: false
# Person Maitas
maitas =
	developing:
		name: "App Development"
		hour: 8
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 17"
		shareTime: true
		shareLocation: false

	clientMeeting:
		name: "Meeting with Client"
		hour: 11
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 101"
		shareTime: true
		shareLocation: false

	lunchtime:
		name: "Lunch Break"
		hour: 13
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Kitchen Area"
		shareTime: true
		shareLocation: false
# Person Matalda
matalda = 
	scrummeeting:
		name: "Scrum Meeting"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 55"
		shareTime: true
		shareLocation: false

	usertesting:
		name: "User testing"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "At Client's Office"
		shareTime: true
		shareLocation: false

	lunchtime:
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Kitchen Area"
		shareTime: true
		shareLocation: true

	clientMeeting:
		name: "Meeting with Client"
		hour: 13
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Room 201"
		shareTime: true
		shareLocation: false

	interview:
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
	standupMeeting:
		name: "Standup Meeting"
		hour: 8
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Room 201"
		shareTime: false
		shareLocation: false

	presentationEvent:
		name: "Presentation Even"
		hour: 10
		minutes: 0
		durationH: 2
		durationM: 0
		location: "Big Hall"
		shareTime: false
		shareLocation: false	

	lunchtime:
		name: "Lunch Break"
		hour: 12
		minutes: 0
		durationH: 1
		durationM: 0
		location: "Out of Office"
		shareTime: false
		shareLocation: false
	
	brainstormingWorkshop:
		name: "Brainstorming"
		hour: 14
		minutes: 0
		durationH: 3
		durationM: 0
		location: "Room 101"
		shareTime: false
		shareLocation: false

activities = []
# Create Activities

itemDataToItemAndSegment = (itemData, checkIn) ->
		activity = instantiateItemFor(itemData, checkIn)
		activities.push(activity)
		sharing = 'shareNothing'
		if itemData.shareTime
			sharing = 'shareTime'
		if (itemData.shareLocation)
			sharing = 'shareLocation'
		redrawSegments(itemData.hour, itemData.durationH, sharing)

createActivitiesFor = (name) ->
	activities = []
	if (name == 'ajla')
		for event of ala
			alaEvent = ala[event.toString()]
			itemDataToItemAndSegment(alaEvent, true)
	else if (name == 'daniel')
		for event of dalan
			dalanEvent = dalan[event.toString()]
			itemDataToItemAndSegment(dalanEvent, false)
	else if (name == 'matilda')
		for event of matalda
			mataldaEvent = matalda[event.toString()]
			itemDataToItemAndSegment(mataldaEvent, false)
	else if (name == 'mattias')
		for event of maitas
			maitasEvent = maitas[event.toString()]
			itemDataToItemAndSegment(maitasEvent, false)
	else if (name == 'paul')
		for event of pol
			polEvent = pol[event.toString()]
			itemDataToItemAndSegment(polEvent, false)

Puck.pinchable.enabled = true
Puck.pinchable.scale = false
Puck.pinchable.centerOrigin = false
Puck.pinchable.rotateIncrements = .5

allSelected = false
# Select by rotate
Puck.onRotate ->
	rotateToSelect()

selectedActivity = null
rotateToSelect = Utils.throttle .1, ->
		selected = false
		deselected = false
		allSelected = false
		puckRotation = Puck.rotation %% 360
		if (puckRotation <= 225 && puckRotation >= 165 && isAuthorised)
			selectedActivity = activities
			allSelected = true
			for activity in activities
				activity.animate('selected')
		else
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
# Change on press (third touch)
Frame.onTouchStart (e) ->
	if (e.touches.length > 2 && selectedActivity && isAuthorised)
		if allSelected
			for activity in selectedActivity
				if (allActivityStatus == 'shareTime')
					activity.shareTime = true
					activity.shareLocation = false
				else if (allActivityStatus == 'shareLocation')
					activity.shareTime = true
					activity.shareLocation = true
				else if (allActivityStatus == 'shareNothing')
					activity.shareTime = false
					activity.shareLocation = false
				updateActivityStatus(activity)
			switch allActivityStatus
				when 'shareNothing'
					allActivityStatus = 'shareTime'
					break
				when 'shareTime'
					allActivityStatus = 'shareLocation'
					break
				else
					allActivityStatus = 'shareNothing'
		else
			allActivityStatus = 'shareNothing'
			updateActivityStatus(selectedActivity)

updateActivityStatus = (activity) ->
	if (allSelected)
		redrawSegments(activity.hour, activity.durationH, allActivityStatus)
		redrawItem(activity)
	else if (!activity.shareTime)
		activity.shareTime = true
		redrawSegments(activity.hour, activity.durationH, 'shareTime')
	else if (!activity.shareLocation)
		activity.shareLocation = true
		redrawSegments(activity.hour, activity.durationH, 'shareLocation')
	else
		activity.shareTime = false
		activity.shareLocation = false
		redrawSegments(activity.hour, activity.durationH, 'shareNothing')
	redrawItem(activity)

redrawSegments = (time, duration, sharing) ->
	for i in [0 ... duration]
		newTime = time + i
		segment = segments[String(newTime)]
		segment.children[0].animate(sharing)
redrawItem = (activity) ->
	if activity.shareTime
		activity.children[1].fill = activeTimeColor
		activity.children[1].borderColor = activeTimeBorderColor
		activity.childrenWithName('NameText').color = activeTextColor
		activity.childrenWithName('TimeText').color = activeTextColor
	else
		activity.children[1].fill = inactiveColor
		activity.children[1].borderColor = inactiveBorderColor
		activity.childrenWithName('NameText').color = inactiveBorderColor
		activity.childrenWithName('TimeText').color = inactiveBorderColor
	if activity.shareLocation
		activity.children[0].fill = activePlaceColor
		activity.children[0].borderColor = activePlaceBorderColor
		activity.children[1].fill = activePlaceColor
		activity.children[1].fill.borderColor = activePlaceBorderColor
		activity.childrenWithName('LocationText').color = activeTextColor
	else
		activity.children[0].fill = inactiveColor
		activity.children[0].borderColor = inactiveBorderColor
		activity.childrenWithName('LocationText').color = inactiveBorderColor

# Create XMLHttpRequest
activePuck = null
parseActivePucks = (data) ->
	switch data
		when '00000'
			for activity in activities
				activity.destroy()
			activePuck = null
			clearSegments()
			Frame.animate('hidden')
			Status.text = "Scan a Puck"
			break
		when '10000'
			if (!activePuck)
				isAuthorised = true
				createActivitiesFor('ajla')
				activePuck = 'ajla'
				Frame.animate('default')
				Status.text = "Checking in Ajla"
			break
		when '01000'
			if (!activePuck)
				isAuthorised = false
				createActivitiesFor('daniel')
				activePuck = 'daniel'
				Frame.animate('default')
				Status.text = "Viewing Daniel's Schedule"
			break
		when '00100'
			if (!activePuck)
				isAuthorised = false
				createActivitiesFor('matilda')
				activePuck = 'matilda'
				Frame.animate('default')
				Status.text = "Viewing Matilda's Schedule"
			break
		when '00010'
			if (!activePuck)
				isAuthorised = false
				createActivitiesFor('mattias')
				activePuck = 'mattias'
				Frame.animate('default')
				Status.text = "Viewing Mattias' Schedule"
			break
		when '00001'
			if (!activePuck)
				isAuthorised = false
				createActivitiesFor('paul')
				activePuck = 'paul'
				Frame.animate('default')
				Status.text = "Viewing Paul's Schedule"
			break
		else
			activities = []
			activePuck = null
			Frame.animate('hidden')	
	
	Utils.delay 2, -> sendRequest()

sendRequest = () ->
	r = new XMLHttpRequest
	r.open 'GET', 'http://42.42.42.42' + '/#' + Math.random(0,100000), true
	r.setRequestHeader('Content-type', 'text/plain')
	r.onreadystatechange = ->
		if (r.readyState == XMLHttpRequest.DONE)
			if (r.status >= 200 && r.status <= 206)
				data = r.response
				parseActivePucks(data)
			else
				print r.status
	r.send()
	
sendRequest()

Button_00000.onTap -> parseActivePucks('00000')
Button_10000.onTap -> parseActivePucks('10000')
Button_01000.onTap -> parseActivePucks('01000')
Button_00100.onTap -> parseActivePucks('00100')
Button_00010.onTap -> parseActivePucks('00010')
Button_00001.onTap -> parseActivePucks('00001')