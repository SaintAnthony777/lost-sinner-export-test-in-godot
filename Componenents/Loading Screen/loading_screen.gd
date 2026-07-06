class_name loadingscreen extends Control
@onready var loader_animator: AnimationPlayer = $"Loader animator"
@onready var loading_status: MarginContainer = $"maincontainer/Loading status"
@onready var confirm_start_game: MarginContainer = $"maincontainer/Confirm start game"
@onready var shown_title: Label = $maincontainer/VBoxContainer/Title_container/Title
@onready var message: Label = $"maincontainer/VBoxContainer/Message container/Message"
@onready var status_percentage:Label=$"maincontainer/Loading status/Status"
@onready var great_dict:Dictionary={
	"Tips":[
			"Rolling can interrupt most of your current actions, use it to evade difficult situations",
			"Successive attacks with the hammer will result that your enemy will be kept at a distance, beware not to be cornered though",
			"Graces and Divine dividers can resverse almost any disavantaged battle, use them when you feel surrounded or if the enemy is stronger than expected",
			"Gifts are really gifts when it comes to infuse more power into ordinary attacks, it can exploit almost any of the enemy's weaknesses, learn to master them"
		],
	"Messages":[
			"To think that someone could have ever defeated the world's strongest man, nothing is eternal. After all we all have this darkness in us now",
			"Halfrey really thought that keeping me in this prison will help the world from falling apart, I do not blame him, even I am sometimes afraid of myself but now even him is no longer and I am to move things now.",
			"Back then Halfrey would visit me once in a while, briefing me on whatever happens outside, it's been so long I did not see him, could it be that he is no longer here? then who commands the guards? ",
			"I still cannot understand why these two gave me their treasures, not that I deny them but I do not think I am Worthy. Still, if they landed in my hands, it means they have fallen for long now."
		],
	"History":[
			"I built this prison with Halfrey with the help of the giants, it was a strategic fortress but now turned into a prison, a prison that is meant to hold me as far away as possible",
			"When I first arrived in this prison, there were a lot of prisoners, mostly were criminals that I konw too much but I could not like. I was stranded in this cell and then it was pitch black for a long time. When I came to Halfrey got me chained and most of the prisoners were dead, all stained with this dark matter.",
			"One day I know that I'll have to go back in the outer world, back to the kingdom, across the seas, back to Archadia. But I know this monster will be waiting for me there. He's waiting for me to be strong enough so that he can use me as his perfect vessel.",
			"I remember when it all started, the skies torn themselves apart, and all of those abominations came out of nowhere guided by the dark hands of these two freaks, they wanted me as I was their so called 'perfect sinner'. Jack, Maerlyn, Halfrey and Ludwig wanted to protect me, even if I was not of their kind."
		],
}
@onready var titles:Array[String]=["Tips","Messages","History"]
@onready var scene_name:String
@onready var scene_load_status:int
@onready var progress:=[]
func shuffle_show()->void:
	var title:String=titles[randi_range(0,2)]
	var message_array:Array=great_dict.get(title)
	var shown_message:String=message_array[randi_range(0,3)]
	shown_title.text=title
	message.text=shown_message
	
func _ready() -> void:
	scene_name=SaveManager.current_save.current_scene
	print(scene_name)
	ResourceLoader.load_threaded_request(scene_name)
	shuffle_show()

func _process(delta: float) -> void:
	scene_load_status=ResourceLoader.load_threaded_get_status(SaveManager.current_save.current_scene,progress)
	status_percentage.text="Loading "+str(floor(progress[0]*100))+" %"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		loading_status.hide();confirm_start_game.show();loader_animator.play("confirm start await")
		if Input.is_action_just_pressed("Jump trigger"):
			SaveManager.new_scene=ResourceLoader.load_threaded_get(SaveManager.current_save.current_scene)
			SaveManager.load_game()
	else : 
		loading_status.show();confirm_start_game.hide();loader_animator.play("loading animation");
		
