# ### Manager Nodes
# resource "aws_autoscaling_schedule" "stop_instances" {
#   scheduled_action_name     = "StopInstances"
#   autoscaling_group_name   = aws_autoscaling_group.swarm_manager_nodes.name
#   desired_capacity          = 0
#   recurrence                = "0 19 * * *"  # Stop instances every day at 7 pm UTC
# }

# resource "aws_autoscaling_schedule" "start_instances" {
#   scheduled_action_name     = "StartInstances"
#   autoscaling_group_name   = aws_autoscaling_group.swarm_manager_nodes.name
#   desired_capacity          = 2  # Adjust this number to the desired number of instances
#   recurrence                = "0 7 * * *"   # Start instances every day at 7 am UTC
# }

# ### Worker Nodes
# resource "aws_autoscaling_schedule" "stop_instances" {
#   scheduled_action_name     = "StopInstances"
#   autoscaling_group_name   = aws_autoscaling_group.swarm_manager_nodes.name
#   desired_capacity          = 0
#   recurrence                = "0 19 * * *"  # Stop instances every day at 7 pm UTC
# }

# resource "aws_autoscaling_schedule" "start_instances" {
#   scheduled_action_name     = "StartInstances"
#   autoscaling_group_name   = aws_autoscaling_group.swarm_manager_nodes.name
#   desired_capacity          = 2  # Adjust this number to the desired number of instances
#   recurrence                = "0 7 * * *"   # Start instances every day at 7 am UTC
# }
