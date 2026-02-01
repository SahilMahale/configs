#!/bin/bash
# Setup script for hyprlock PIN authentication

set -e

echo "Setting up hyprlock PIN authentication..."

# Create custom PAM service for hyprlock PIN
echo "Creating PAM service for hyprlock PIN..."
sudo tee /etc/pam.d/hyprlock-pin > /dev/null << 'EOF'
#%PAM-1.0
auth required pam_exec.so expose_authtok /usr/local/bin/hyprlock-pin-verify
account required pam_permit.so
session required pam_permit.so
EOF

# Create PIN verification script
echo "Creating PIN verification script..."
sudo tee /usr/local/bin/hyprlock-pin-verify > /dev/null << 'EOF'
#!/bin/bash
PIN_FILE="/home/$PAM_USER/.config/hypr/hyprlock-pin"
if [ ! -f "$PIN_FILE" ]; then
    exit 1
fi
read -s input_pin
input_hash=$(echo -n "$input_pin" | sha256sum | cut -d' ' -f1)
stored_hash=$(cat "$PIN_FILE")
[ "$input_hash" = "$stored_hash" ] && exit 0 || exit 1
EOF

# Make script executable
echo "Making verification script executable..."
sudo chmod +x /usr/local/bin/hyprlock-pin-verify

# Create PIN
echo "Setting up your PIN..."
mkdir -p ~/.config/hypr
echo -n "Enter your PIN for hyprlock: "
read -s pin
echo
echo -n "Confirm your PIN: "
read -s pin_confirm
echo

if [ "$pin" != "$pin_confirm" ]; then
    echo "PINs do not match! Exiting."
    exit 1
fi

# Create PIN hash
echo -n "$pin" | sha256sum | cut -d' ' -f1 > ~/.config/hypr/hyprlock-pin
chmod 600 ~/.config/hypr/hyprlock-pin

# Update hyprlock.conf
echo "Updating hyprlock.conf..."
if ! grep -q "auth pam_service hyprlock-pin" ~/.config/hypr/hyprlock.conf; then
    echo "auth pam_service hyprlock-pin" >> ~/.config/hypr/hyprlock.conf
fi

echo "Setup complete! Your hyprlock will now use PIN authentication."
echo "Your login password remains unchanged for system login."