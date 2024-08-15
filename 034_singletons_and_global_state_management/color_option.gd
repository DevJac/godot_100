extends OptionButton


const colors = {
	0: Color.RED,
	1: Color.BLUE,
}


var color: Color:
	get:
		return colors[selected]
