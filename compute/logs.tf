#---compute/logs.tf

# Set up cloudwatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "endava_log_group" {
    name              = "/ecs/endava-app"
    retention_in_days = 30

    tags = {
        Name = "endava-log-group"
    }
}

resource "aws_cloudwatch_log_stream" "endava_log_stream" {
    name           = "endava-log-stream"
    log_group_name = "${aws_cloudwatch_log_group.endava_log_group.name}"
}
