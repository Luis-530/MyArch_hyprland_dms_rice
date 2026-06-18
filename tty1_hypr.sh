#!/usr/bin/env bash
# Boot straight into Hyprland on tty1 — no display manager (no SDDM).
#
# Pairs with ~/.zprofile, which already contains `exec Hyprland` on tty1.
# This script installs the missing piece: a systemd override that logs you
# in on tty1 with no password, so the shell-profile launch runs automatically.
#
# Run as your normal user (e.g. `./tty1_hypr.sh`). The sudo prompts will ask
# for your password; credentials are cached after the first prompt.

set -euo pipefail

USER_NAME="Luis"
DROP_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE="${DROP_DIR}/override.conf"

echo "==> Installing getty@tty1 autologin override for user: ${USER_NAME}"
sudo mkdir -p "${DROP_DIR}"
# ${USER_NAME} expands here; \$TERM is written literally so systemd expands it at runtime.
sudo tee "${OVERRIDE}" > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${USER_NAME} --noclear %I \$TERM
Type=idle
EOF

echo "==> Reloading systemd"
sudo systemctl daemon-reload

echo "==> Enabling getty@tty1.service"
sudo systemctl enable getty@tty1.service

echo "==> Done. Override contents:"
cat "${OVERRIDE}"
echo
echo "Status: $(systemctl is-enabled getty@tty1.service)"
echo "Reboot to boot straight into Hyprland."
