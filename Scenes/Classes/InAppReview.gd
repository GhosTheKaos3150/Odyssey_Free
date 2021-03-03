extends Node

var review

#func _ready():
#	review = Engine.get_singleton("ReviewPlugin")
#
#	review.connect("review_flow_started", self, "review_flow_started")
#	review.connect("review_flow_finished", self, "review_flow_finished")
#	review.connect("review_info_request_unsuccessful", self, "review_info_request_unsuccessful")

func review_flow_started():
	print ("request review começou")

func review_flow_finished():
	print ("request review acabou")
	Global.review = true

func review_info_request_unsuccessful():
	print("review não funfou")
