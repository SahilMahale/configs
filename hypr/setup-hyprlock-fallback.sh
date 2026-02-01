#!/bin/bash
# Setup script for hyprlock PIN authentication with password fallback

set -e

echo "Setting up hyprlock PIN authentication with password fallback..."

# Create updated PAM service for hyprlock PIN with fallback
echo "Creating PAM service with fallback..."
sudo tee /etc/pam.d/hyprlock-pin > /dev/null << 'EOF'
#%PAM-1.0
# Try PIN first, if it fails, fall back to password authentication
auth [success=done new_authtok_reqd=done default=ignore] pam_exec.so expose_authtok /usr/local/bin/hyprlock-pin-verify
auth include system-auth
account required pam_permit.so
session required pam_permit.so
EOF

# Create updated PIN verification script with better error handling
echo "Creating updated PIN verification script..."
sudo tee /usr/local/bin/hyprlock-pin-verify > /dev/null << 'EOF'
#!/bin/bash
PIN_FILE="/home/$PAM_USER/.config/hypr/hyprlock-pin"

# If no PIN file exists, fail silently to allow password fallback
if [ ! -f "$PIN_FILE" ]; then
    exit 1
fi

# Read input (PIN attempt)
read -s input_pin

# If input is empty, fail to allow password fallback
if [ -z "$input_pin" ]; then
    exit 1
fi

# Generate hash of input
input_hash=$(echo -n "$input_pin" | sha256sum | cut -d' ' -f1)
stored_hash=$(cat "$PIN_FILE")

# Check if PIN matches
if [ "$input_hash" = "$stored_hash" ]; then
    exit 0
else
    exit 1
fi
EOF

# Make script executable
echo "Making verification script executable..."
sudo chmod +x /usr/local/bin/hyprlock-pin-verify

echo "Setup complete! Your hyprlock will now try PIN first, then fall back to password."
echo "- Enter your PIN to unlock quickly"
echo "- If PIN fails or you forget it, you can use your regular password"
echo "- Your system login password remains unchanged"