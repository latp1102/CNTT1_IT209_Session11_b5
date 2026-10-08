#!/bin/bash
set -euo pipefail

LOG_DIR="/home/devops_exam"
LOG_FILE="${LOG_DIR}/system_audit.log"
mkdir -p "${LOG_DIR}"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log "===== SYSTEM AUDIT START ====="

log "[CHECK] User devops_exam exists"
if id devops_exam &>/dev/null; then
  log "OK: devops_exam exists"
else
  log "FAIL: devops_exam not found"
fi

log "[CHECK] Group docker exists"
if getent group docker &>/dev/null; then
  log "OK: docker group exists"
else
  log "FAIL: docker group not found"
fi

log "[CHECK] devops_exam membership in docker"
if groups devops_exam 2>/dev/null | grep -qw docker; then
  log "OK: devops_exam is member of docker"
else
  log "FAIL: devops_exam is NOT member of docker"
fi

log "[CHECK] setup.sh permission"
if [ -f /home/devops_exam/app/setup.sh ]; then
  perms=$(stat -c '%a' /home/devops_exam/app/setup.sh)
  log "setup.sh permission: ${perms}"
  if [ "${perms}" = "700" ]; then
    log "OK: setup.sh has permission 700"
  else
    log "FAIL: setup.sh permission is ${perms}, expected 700"
  fi
else
  log "FAIL: /home/devops_exam/app/setup.sh not found"
fi

log "[CHECK] Disk usage /"
df -h / | tee -a "${LOG_FILE}"

log "[CHECK] RAM"
free -h | tee -a "${LOG_FILE}"

log "[CHECK] Java JDK 17"
java -version 2>&1 | tee -a "${LOG_FILE}" || log "Java not found"

log "[CHECK] Docker Engine"
docker --version 2>&1 | tee -a "${LOG_FILE}" || log "Docker not found"

log "===== SYSTEM AUDIT END ====="
