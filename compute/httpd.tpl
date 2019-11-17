[{
  "name": "httpd",
  "image": "${httpd_docker_image}",
  "cpu": 256,
  "memory": 256,
  "essential": true,
  "portMappings": [{
    "containerPort": 80,
    "hostPort": 80
  }],
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "httpd_log_group",
      "awslogs-region": "${aws_region}",
      "awslogs-stream-prefix": "httpd_log_stream"
    }
  },
  "command": [],
  "entryPoint": [],
  "links": [],
  "mountPoints": [],
  "volumesFrom": [],
  "environment": [
    { "name": "PMA_HOST", "value": "${endpoint}" }
  ]
}]
