extends Control

var default_velocity := 100.0
var label_velocity := Vector2(default_velocity, default_velocity)


# Called when the node enters the scene tree for the first time.
func _ready():
	var font = $Label.label_settings.font
	var font_size = $Label.label_settings.font_size
	var ts = TextServerManager.get_primary_interface()
	var shaped = ts.create_shaped_text()
	ts.shaped_text_add_string(shaped, $Label.text, font.get_rids(), font_size)
	
	var x = 0.0
	var y = 0.0
	var ascent = font.get_ascent(font_size)
	var glyphs = ts.shaped_text_get_glyphs(shaped)
	var tight_rect = Rect2()
	for g in glyphs:
		var g_offset = ts.font_get_glyph_offset(g.font_rid, Vector2i(g.font_size, 0), g.index)
		var g_size = ts.font_get_glyph_size(g.font_rid, Vector2i(g.font_size, 0), g.index)
		var glyph_rect = Rect2(Vector2(x, y + ascent) + g_offset, g_size)
		if not tight_rect.has_area():
			tight_rect = glyph_rect
		else:
			tight_rect = tight_rect.merge(glyph_rect)
		# The following will make a tight binding box around each glyph
		#var ref_rect = ReferenceRect.new()
		#ref_rect.position = glyph_rect.position
		#ref_rect.size = glyph_rect.size
		#ref_rect.editor_only = false
		#$Label.add_child(ref_rect)
		x += g.advance
	var ref_rect = ReferenceRect.new()
	ref_rect.position = tight_rect.position
	ref_rect.size = tight_rect.size
	ref_rect.editor_only = false
	ref_rect.name = 'TextBounds'
	$Label.add_child(ref_rect)
	
	########################################################
	# Resource cleanup, will leak memory without this
	ts.free_rid(shaped)
	########################################################


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.position += label_velocity * delta
	
	var text_pos = $Label/TextBounds.global_position
	var text_end = $Label/TextBounds.global_position + $Label/TextBounds.size
	var bounce = Vector2(0.0, 0.0)
	# Left, Right, Top, Bottom Bounces
	if text_pos.x < 0:
		bounce.x += default_velocity
	if text_end.x > size.x:
		bounce.x -= default_velocity
	if text_pos.y < 0:
		bounce.y += default_velocity
	if text_end.y > size.y:
		bounce.y -= default_velocity
	
	if bounce.x != 0:
		label_velocity.x = bounce.x
	if bounce.y != 0:
		label_velocity.y = bounce.y

	if Time.get_ticks_msec() > 30 * 1000:
		$Label/TextBounds.editor_only = true
