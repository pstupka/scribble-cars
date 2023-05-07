extends RichTextLabel

const COLORS := [
	"#4b80ca",
	"#68c2d3",
	"#ede19e",
	"#b45252",
	"#d3a068",
	"#cf8acb",
	"#8ab060",
	"#edc8c4",
	"#b8b5b9",
	"#b2b47e",
	"#c2d368",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var text_buffer := ""
	var i = randi() % COLORS.size();
	for letter in bbcode_text:
		i += 1
		var color_str = COLORS[i % COLORS.size()]
		text_buffer += "[color=%s]%s[/color]" % [color_str, letter]
	bbcode_text = "[center][wave amp=25.0 freq=5.0]" + text_buffer + "[/wave][/center]"
