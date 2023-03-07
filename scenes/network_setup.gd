extends Control


onready var multiplayer_config_ui = $MultiplayerConfigure
onready var server_ip_address = $MultiplayerConfigure/CenterContainer/VBoxContainer2/ServerIpAddress

onready var device_ip_address = $MultiplayerConfigure/CanvasLayer/HBoxContainer/DeviceIp


func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnedted")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address


func _player_connected(id) -> void:
	print("CONNECTED : Player " + str(id))


func _player_disconnected(id) -> void:
	print("DISCONNECTED: Player " + str(id))


func _on_CreateServer_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()


func _on_JoinServer_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()
