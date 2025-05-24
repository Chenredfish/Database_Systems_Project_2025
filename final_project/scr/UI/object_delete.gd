extends Node

func _object_delete(db, object, id):
	db.delete_rows(object, "id = '" + id + "'")

func _refresh_database(db, object):
	var new_db = db.select_rows(object, "id > 0", ["*"])
	return new_db
