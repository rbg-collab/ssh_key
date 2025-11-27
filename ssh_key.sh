#!/bin/bash
# Description: Creates the default Ed25519 SSH key pair named 'id_ed25519'
# in the ~/.ssh/ directory if it doesn't exist, and displays the public key.

# Default SSH key names
KEY_NAME="id_ed25519"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUB_KEY_PATH="$KEY_PATH.pub"
COMMENT="id_ed25519-$(whoami)@$(hostname)"

echo "--- SSH Key Check and Management ---"
echo "Target Key: $KEY_PATH"

# 1. Check if the private key file already exists
if [ -f "$KEY_PATH" ]; then
    echo ""
    echo "✅ SSH private key '$KEY_NAME' already exists."
    
    # Ensure the public key also exists
    if [ -f "$PUB_KEY_PATH" ]; then
        echo "Displaying existing public key content:"
        echo "--------------------------------------------------------------------------------"
        cat "$PUB_KEY_PATH"
        echo "--------------------------------------------------------------------------------"
    else
        echo "⚠️ Warning: Private key exists, but public key ($PUB_KEY_PATH) is missing."
        echo "Attempting to regenerate public key from private key..."
        
        # Regenerate public key from private if possible
        ssh-keygen -y -f "$KEY_PATH" > "$PUB_KEY_PATH" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "Successfully regenerated public key."
            echo "Displaying regenerated public key content:"
            echo "--------------------------------------------------------------------------------"
            cat "$PUB_KEY_PATH"
            echo "--------------------------------------------------------------------------------"
        else
            echo "❌ Error: Could not regenerate public key. Private key might be corrupted."
        fi
    fi
else
    # Key does not exist: generate a new one
    echo ""
    echo "🔑 Default SSH key '$KEY_NAME' not found. Generating a new Ed25519 key..."
    
    ssh-keygen -t ed25519 -f "$KEY_PATH" -C "$COMMENT"
    
    if [ $? -eq 0 ]; then
        echo "✅ Key generation complete."
        echo "Displaying the NEW public key content:"
        echo "--------------------------------------------------------------------------------"
        cat "$PUB_KEY_PATH"
        echo "--------------------------------------------------------------------------------"
    else
        echo "❌ Key generation failed. Please check for errors above."
    fi
fi

echo ""
echo "Script finished."
