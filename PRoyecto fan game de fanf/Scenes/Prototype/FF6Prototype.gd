extends Control

const MODE_ADVENTURE := "adventure"
const MODE_BATTLE := "battle"
const MODE_VICTORY := "victory"

var mode := MODE_ADVENTURE
var stage := 0
var enemy_hp := 0
var player_hp := 160
var player_mp := 54
var player_limit := 0
var has_magitek_core := false
var shadow_joined := false

@onready var title_label: Label = $MarginContainer/MainLayout/TopBar/TitleBlock/TitleLabel
@onready var subtitle_label: Label = $MarginContainer/MainLayout/TopBar/TitleBlock/SubtitleLabel
@onready var objective_label: Label = $MarginContainer/MainLayout/Body/Sidebar/ObjectivePanel/ObjectiveMargin/ObjectiveLabel
@onready var story_label: RichTextLabel = $MarginContainer/MainLayout/Body/CenterColumn/StoryPanel/StoryMargin/StoryText
@onready var log_label: RichTextLabel = $MarginContainer/MainLayout/BottomSection/BattleLogPanel/BattleLogMargin/BattleLogText
@onready var hero_stats_label: Label = $MarginContainer/MainLayout/Body/Sidebar/PartyPanel/PartyMargin/HeroStats
@onready var inventory_label: Label = $MarginContainer/MainLayout/Body/Sidebar/InventoryPanel/InventoryMargin/InventoryLabel
@onready var primary_button: Button = $MarginContainer/MainLayout/BottomSection/CommandPanel/CommandMargin/CommandBox/CommandGrid/PrimaryButton
@onready var secondary_button: Button = $MarginContainer/MainLayout/BottomSection/CommandPanel/CommandMargin/CommandBox/CommandGrid/SecondaryButton
@onready var tertiary_button: Button = $MarginContainer/MainLayout/BottomSection/CommandPanel/CommandMargin/CommandBox/CommandGrid/TertiaryButton
@onready var quaternary_button: Button = $MarginContainer/MainLayout/BottomSection/CommandPanel/CommandMargin/CommandBox/CommandGrid/QuaternaryButton
@onready var menu_button: Button = $MarginContainer/MainLayout/BottomSection/CommandPanel/CommandMargin/CommandBox/MenuButton
@onready var background_rect: TextureRect = $MarginContainer/MainLayout/Body/CenterColumn/ViewportPanel/ViewportMargin/Viewport/ViewportPanel/BackgroundRect
@onready var overlay_rect: TextureRect = $MarginContainer/MainLayout/Body/CenterColumn/ViewportPanel/ViewportMargin/Viewport/ViewportPanel/OverlayRect

func _ready() -> void:
	MusicManager.playGameMusic()
	_update_ui()
	_show_intro()

func _show_intro() -> void:
	stage = 0
	enemy_hp = 0
	player_hp = 160
	player_mp = 54
	player_limit = 0
	has_magitek_core = false
	shadow_joined = false
	title_label.text = "FINAL FANTASY VI: Ecos del Veldt"
	subtitle_label.text = "Prototipo narrativo hecho sobre los assets heredados del proyecto"
	story_label.text = "[center][b]Prólogo[/b][/center]\n\nTras la caída del Imperio, una señal magitek vuelve a encenderse en un teatro abandonado al borde del Veldt.\n\nTerra entra con una pequeña avanzadilla para recuperar un núcleo de energía, rescatar supervivientes y detener a una bestia de guerra reactivada.\n\nEste prototipo mezcla exploración guiada, selección de comandos y un combate corto por turnos."
	log_label.text = "[b]Misión activa:[/b] inspecciona el escenario ruinoso y encuentra el núcleo magitek."
	objective_label.text = "1. Examina el teatro improvisado.\n2. Localiza el núcleo magitek.\n3. Prepárate para el guardián imperial."
	background_rect.texture = load("res://Graphics/Office/Gemini_Generated_Image_uwr2yuwr2yuwr2yu.png")
	overlay_rect.texture = load("res://Graphics/Static/static_anim.png")
	overlay_rect.modulate = Color(1, 1, 1, 0.08)
	_set_adventure_buttons("Inspeccionar", "Hablar", "Sincronizar", "Descansar")
	_update_ui()

func _update_ui() -> void:
	hero_stats_label.text = "Terra Branford\nHP %d / 160\nMP %d / 54\nTrance %d%%" % [player_hp, player_mp, player_limit]
	var inventory_lines := ["- Capa de viaje", "- 2 Pócimas", "- 1 Éter"]
	if has_magitek_core:
		inventory_lines.append("- Núcleo magitek rescatado")
	if shadow_joined:
		inventory_lines.append("- Shadow cubre la retaguardia")
	inventory_label.text = "\n".join(inventory_lines)

func _set_adventure_buttons(a: String, b: String, c: String, d: String) -> void:
	mode = MODE_ADVENTURE
	primary_button.text = a
	secondary_button.text = b
	tertiary_button.text = c
	quaternary_button.text = d

func _set_battle_buttons() -> void:
	mode = MODE_BATTLE
	primary_button.text = "Magic"
	secondary_button.text = "Runic"
	tertiary_button.text = "Item"
	quaternary_button.text = "Defender"

func _on_primary_button_pressed() -> void:
	match mode:
		MODE_ADVENTURE:
			_handle_explore()
		MODE_BATTLE:
			_cast_spell()
		MODE_VICTORY:
			_return_to_menu()

func _on_secondary_button_pressed() -> void:
	match mode:
		MODE_ADVENTURE:
			_handle_talk()
		MODE_BATTLE:
			_use_runic()
		MODE_VICTORY:
			_show_epilogue()

func _on_tertiary_button_pressed() -> void:
	match mode:
		MODE_ADVENTURE:
			_handle_scan()
		MODE_BATTLE:
			_use_item()
		MODE_VICTORY:
			_show_intro()

func _on_quaternary_button_pressed() -> void:
	match mode:
		MODE_ADVENTURE:
			_handle_rest()
		MODE_BATTLE:
			_defend_turn()
		MODE_VICTORY:
			_show_epilogue()

func _handle_explore() -> void:
	if stage == 0:
		stage = 1
		story_label.text = "[b]Exploración[/b]\n\nDetrás del telón hay una consola vieja alimentada por tubos magitek improvisados. Las tablas crujen y el aire huele a ozono.\n\nEntre cajas rotas encuentras un mapa de rutas imperiales: el teatro servía de puesto de escucha."
		log_label.text = "Terra encontró un registro imperial y confirmó que alguien trató de reactivar un guardián de guerra."
		objective_label.text = "1. Interroga a los presentes.\n2. Sincroniza la consola.\n3. Descubre quién protege el núcleo."
		background_rect.texture = load("res://Graphics/backrooms/Oficina - copia.png")
		overlay_rect.texture = load("res://Graphics/Tablet/tablet_anim.png")
		overlay_rect.modulate = Color(1, 1, 1, 0.12)
	elif stage == 1:
		stage = 2
		has_magitek_core = true
		player_limit = min(player_limit + 20, 100)
		story_label.text = "[b]Hallazgo[/b]\n\nDentro del escritorio central recuperas un [color=yellow]núcleo magitek[/color] aún caliente. El pulso del cristal responde a Terra como si reconociera su afinidad con los espers.\n\nPero al retirar el núcleo, una compuerta negra se abre al fondo del salón."
		log_label.text = "Objeto clave obtenido: Núcleo magitek. Una firma hostil se mueve al otro lado de la compuerta."
		objective_label.text = "1. Reúne información final.\n2. Prepárate para una emboscada.\n3. Mantén el núcleo a salvo."
		background_rect.texture = load("res://Graphics/CamRooms/Camaras.png")
		overlay_rect.texture = load("res://Graphics/Static/static_anim.png")
		overlay_rect.modulate = Color(1, 0.8, 0.8, 0.16)
		_update_ui()
	else:
		_start_battle()

func _handle_talk() -> void:
	if not shadow_joined:
		shadow_joined = true
		player_limit = min(player_limit + 10, 100)
		story_label.text = "[b]Encuentro[/b]\n\nUna figura emerge desde la oscuridad del bastidor: [color=gray]Shadow[/color]. No hace preguntas; sólo señala la compuerta y murmura que la máquina del Imperio ya ha olido el núcleo.\n\n'Yo cubriré la retirada. Tú mantén a raya a esa cosa.'"
		log_label.text = "Shadow se une como apoyo narrativo. Tu barra de Trance aumenta un poco por la tensión del momento."
	else:
		story_label.text = "[b]Consejo táctico[/b]\n\nShadow observa las marcas del suelo. 'El guardián cargará primero contra la magia. Si quieres abrir brecha, alterna hechizos con defensa.'"
		log_label.text = "Consejo recibido: combina presión mágica con turnos defensivos para aguantar."
	_update_ui()

func _handle_scan() -> void:
	if stage < 2:
		story_label.text = "[b]Sincronización[/b]\n\nLa pantalla de la consola muestra planos distorsionados del teatro. Detectas tres focos de energía: escenario, despacho y conducto central.\n\nLa lectura final identifica un [color=red]Prototipo Magitek A-6[/color] en modo centinela."
		log_label.text = "Análisis completo. El enemigo final es vulnerable al hielo y tarda en recargar tras bloquear magia."
		player_limit = min(player_limit + 5, 100)
	else:
		story_label.text = "[b]Lectura del núcleo[/b]\n\nCon el cristal en la mano, Terra percibe ecos de una melodía antigua. Es suficiente para estabilizar el salón unos minutos más, pero también despierta al guardián por completo."
		log_label.text = "El núcleo reacciona contigo. Ya no queda tiempo: prepárate para combatir."
	_update_ui()

func _handle_rest() -> void:
	player_hp = min(player_hp + 20, 160)
	player_mp = min(player_mp + 10, 54)
	story_label.text = "[b]Respiro breve[/b]\n\nTerra se concentra, regula su pulso y deja que la energía del núcleo selle sus heridas menores. El silencio sólo dura unos segundos."
	log_label.text = "Descanso corto: HP +20, MP +10. El peligro sigue acechando tras la compuerta."
	_update_ui()

func _start_battle() -> void:
	mode = MODE_BATTLE
	enemy_hp = 180
	background_rect.texture = load("res://Graphics/backrooms/Termina la noche.png")
	overlay_rect.texture = load("res://Graphics/Static/static_anim.png")
	overlay_rect.modulate = Color(1, 0.5, 0.5, 0.12)
	story_label.text = "[center][b]COMBATE[/b][/center]\n\nEl [color=red]Prototipo Magitek A-6[/color] irrumpe entre chispas y metal retorcido. Su coraza absorbe parte de la luz del salón.\n\nTerra da un paso al frente mientras Shadow desaparece entre las sombras del escenario."
	log_label.text = "Enemigo detectado: Prototipo Magitek A-6. HP enemigo: %d." % enemy_hp
	objective_label.text = "Derrota al guardián antes de que el núcleo se sobrecargue."
	_set_battle_buttons()
	_update_ui()

func _cast_spell() -> void:
	if player_mp < 12:
		log_label.text = "No queda suficiente MP para lanzar Blizzard. Considera usar un objeto o defenderte."
		return
	player_mp -= 12
	var damage := 36 + randi() % 18
	enemy_hp = max(enemy_hp - damage, 0)
	player_limit = min(player_limit + 15, 100)
	log_label.text = "Terra lanza Blizzard y quiebra la armadura del guardián. Daño: %d. HP enemigo restante: %d." % [damage, enemy_hp]
	story_label.text = "El hielo cubre las juntas del Prototipo A-6. La máquina retrocede, pero su reactor sigue rugiendo."
	_enemy_turn(14, 24)

func _use_runic() -> void:
	player_limit = min(player_limit + 10, 100)
	log_label.text = "Terra canaliza una Runic improvisada con el núcleo. El próximo pulso enemigo pierde intensidad."
	story_label.text = "Un sello azul envuelve a Terra. La energía magitek del escenario se desvía hacia el cristal en sus manos."
	_enemy_turn(6, 14)

func _use_item() -> void:
	player_hp = min(player_hp + 35, 160)
	log_label.text = "Terra usa una Poción. Recupera 35 HP y recompone la formación."
	story_label.text = "El líquido brillante corta el dolor un instante. Shadow lanza una daga para mantener ocupado al enemigo."
	_enemy_turn(10, 20)

func _defend_turn() -> void:
	player_limit = min(player_limit + 8, 100)
	log_label.text = "Terra adopta una postura defensiva. Reduce el impacto del siguiente ataque mientras estudia el patrón del autómata."
	story_label.text = "La máquina descarga vapor y metralla contra el escenario. Terra aguanta detrás de una columna caída."
	_enemy_turn(4, 10)

func _enemy_turn(min_damage: int, max_damage: int) -> void:
	if enemy_hp <= 0:
		_show_victory()
		return
	var damage := min_damage + randi() % max(1, max_damage - min_damage + 1)
	player_hp = max(player_hp - damage, 0)
	if player_hp <= 0:
		player_hp = 48
		player_mp = max(player_mp, 10)
		player_limit = 100
		story_label.text = "[b]Último impulso[/b]\n\nCuando todo parece perdido, el núcleo responde al linaje de Terra y libera una oleada de luz. El escenario se recompone lo suficiente para darte una segunda oportunidad."
		log_label.text = "El Trance evita la derrota. Terra se mantiene en pie con 48 HP y la determinación al máximo."
	_update_ui()
	if enemy_hp <= 0:
		_show_victory()

func _show_victory() -> void:
	mode = MODE_VICTORY
	background_rect.texture = load("res://Graphics/Menu/interfas v1..jpeg")
	overlay_rect.texture = load("res://Graphics/Tablet/tablet_anim.png")
	overlay_rect.modulate = Color(1, 0.9, 0.9, 0.08)
	story_label.text = "[center][b]Victoria[/b][/center]\n\nEl Prototipo A-6 colapsa entre vapor y chispas. El teatro queda en silencio por primera vez en años.\n\nTerra asegura el núcleo, Shadow desaparece sin despedirse y una nueva ruta hacia el Veldt se abre frente al grupo."
	log_label.text = "Demo completada. Has recuperado el núcleo magitek y liberado el puesto imperial abandonado."
	objective_label.text = "Fin del prototipo. Puedes volver al menú, releer el epílogo o reiniciar la demo."
	primary_button.text = "Volver al menú"
	secondary_button.text = "Epílogo"
	tertiary_button.text = "Reiniciar demo"
	quaternary_button.text = "Epílogo"
	_update_ui()

func _show_epilogue() -> void:
	story_label.text = "[b]Epílogo[/b]\n\nCon el núcleo a salvo, Terra planea llevarlo a Figaro para estudiarlo lejos del alcance imperial.\n\nEl siguiente hito ideal para este fangame sería expandir el mapa del teatro, añadir sprites explorables, estados alterados y un sistema real de grupo con Locke, Celes y Sabin."
	log_label.text = "Próxima iteración sugerida: mapa navegable + combate por ATB + eventos con sprites y diálogos ramificados."

func _return_to_menu() -> void:
	get_tree().change_scene_to_file("res://Graphics/Menu/MainMenu.tscn")

func _on_menu_button_pressed() -> void:
	_return_to_menu()
