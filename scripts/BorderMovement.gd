extends StaticBody2D

export var dir = 0;
export var hp = 100;
export var posX = 0;
export var posY = 0;

var speed = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(posY);
	if (dir == 0):
		self.position = Vector2(posX, posY + hp - 100);
	if (dir == 1):
		self.position = Vector2(posX, posY - hp + 100);
	if (dir == 2):
		self.position = Vector2(posX + hp - 100, posY);
	if (dir == 3):
		self.position = Vector2(posX - hp + 100, posY);
