#---compute/logs.tf

# Set up cloudwatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "httpd_log_group" {
    name              = "/ecs/httpd"
    retention_in_days = 30

    tags {
        Name = "httpd-log-group"
    }
}

resource "aws_cloudwatch_log_stream" "httpd_log_stream" {
    name           = "httpd-log-stream"
    log_group_name = "${aws_cloudwatch_log_group.httpd_log_group.name}"
}
