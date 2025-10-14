locals {
  smarttask_log_all = <<EOT
#!/bin/bash

# not for production use - mind log rotation!
LOGFILE="/var/log/smarttasks.log"

# is $1 file path?
if [[ ! -f "$1" ]]; then
  echo "Error: Input is not a file." >&2
else
    # append formatted to logfile
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
    cat "$1" | jq -c .  >> "$LOGFILE"
    echo >> "$LOGFILE"
fi

printf '{"result":"success"}\n'
exit 0
EOT
}

resource "checkpoint_management_repository_script" "smarttask_log_all" {
  name        = "SmartTask Log All"
  script_body = local.smarttask_log_all
}

resource "checkpoint_management_smart_task" "smarttask_log_all_before_publish" {
  name    = "Before Publish - Log All"
  trigger = "Before Publish"
  action {
    run_script {
      repository_script = checkpoint_management_repository_script.smarttask_log_all.name
    }
  }
  enabled = true
  custom_data = jsonencode({
    a = 10
    b = 20
    c = "Hello World"
    d = { z : 14, y : "test" }
  })
}