#!/bin/bash
# Description: Creates an Ed25519 SSH key pair named 'ssh_key' in the default
# ~/.ssh/ directory if it doesn't exist, and displays the public key.
# It uses the highly secure Ed25519 algorithm.

# Define the full path for the key files
KEY_NAME="ssh_key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUB_KEY_PATH="$KEY_PATH.pub"
COMMENT="ssh_key-$(whoami)@$(hostname)"

echo "--- SSH Key Check and Management ---"
echo "Target Key: $KEY_PATH"

# 1. Check if the private key file already exists
if [ -f "$KEY_PATH" ]; then
    # Key exists: display the public key
    echo ""
    echo "✅ SSH private key '$KEY_NAME' already exists."
    
    # Ensure the public key also exists before trying to display it
    if [ -f "$PUB_KEY_PATH" ]; then
        echo "Displaying existing public key content (to copy to GitHub/server):"
        echo "--------------------------------------------------------------------------------"
        cat "$PUB_KEY_PATH"
        echo "--------------------------------------------------------------------------------"
    else
        echo "⚠️ Warning: Private key exists, but public key ($PUB_KEY_PATH) is missing."
        echo "Attempting to regenerate public key from private key..."
        # Use a fallback command to recover the public key if the private key exists but the public key is missing
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
    echo "🔑 SSH key pair '$KEY_NAME' not found. Starting generation of a new Ed25519 key..."
    
    # Generate the key. -t specifies the type, -f specifies the filename, -C adds a comment.
    # The command will prompt you for a passphrase. Leave it blank by pressing Enter for no passphrase.
    ssh-keygen -t ed25519 -f "$KEY_PATH" -C "$COMMENT"
    
    # Check if the key generation was successful
    if [ $? -eq 0 ]; then
        echo "✅ Key generation complete."
        echo "Displaying the NEW public key content (to copy to GitHub/server):"
        echo "--------------------------------------------------------------------------------"
        cat "$PUB_KEY_PATH"
        echo "--------------------------------------------------------------------------------"
    else
        echo "❌ Key generation failed. Please check for errors above."
    fi
fi

echo ""
echo "Script finished."
