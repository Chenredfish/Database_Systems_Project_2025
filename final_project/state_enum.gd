extends Node

enum GAME_STATE_TYPE{
	PLAYING, ##正在遊玩
	READY, ##遊戲結算
	SHOW_RING, ##查看ring
	MANAGE_MAIN, ##管理者主畫面
	MANAGE_CHANGE, ##變更actor, skill, equipment, type
	MANAGE_CHANGE_RING, ##變更ring
}
