# Multiple git accounts using ssh
Created: 1/6/2025, 4:07:36 pm
Last Updated: 1/6/2025, 5:13:30 pm
---

### User

I want to configure my local git with 2 different accounts based on the folder 
1) work
2) personal 
can I achieve this using SSH


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The user wants to configure Git to use different accounts based on folders (work vs personal) using SSH. This is a common need for developers who have both work and personal GitHub/GitLab accounts.

Here's what they need to do:
1. Generate separate SSH key pairs for work and personal accounts
2. Configure SSH config to use different keys for different hosts
3. Set up Git configuration to use different settings based on directory
4. Optionally use Git's conditional includes feature

Let me provide a comprehensive solution.
</details>

Yes, absolutely! You can configure Git to use different accounts based on folders using SSH keys and Git's conditional includes. Here's a complete setup:

## 1. Generate Separate SSH Key Pairs

```bash
# Generate SSH key for work account
ssh-keygen -t ed25519 -C "your-work-email@company.com" -f ~/.ssh/id_ed25519_work

# Generate SSH key for personal account
ssh-keygen -t ed25519 -C "your-personal-email@gmail.com" -f ~/.ssh/id_ed25519_personal
```

## 2. Add SSH Keys to SSH Agent

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add both keys
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```

## 3. Configure SSH Config

Create/edit `~/.ssh/config`:

```bash
# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
```

## 4. Add SSH Keys to GitHub Accounts

Copy the public keys and add them to respective GitHub accounts:

```bash
# Copy work public key
cat ~/.ssh/id_ed25519_work.pub

# Copy personal public key
cat ~/.ssh/id_ed25519_personal.pub
```

## 5. Configure Git with Conditional Includes

Edit your global Git config (`~/.gitconfig`):

```ini
[user]
    # Default configuration (can be your personal)
    name = Your Name
    email = your-personal-email@gmail.com

[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work

[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

## 6. Create Separate Git Configs

Create `~/.gitconfig-work`:

```ini
[user]
    name = Your Work Name
    email = your-work-email@company.com
```

Create `~/.gitconfig-personal`:

```ini
[user]
    name = Your Personal Name
    email = your-personal-email@gmail.com
```

## 7. Clone Repositories Using Correct SSH Hosts

```bash
# For work repositories (in ~/work/ folder)
git clone git@github-work:company/repo-name.git

# For personal repositories (in ~/personal/ folder)
git clone git@github-personal:username/repo-name.git
```

## 8. Verify Configuration

Test the setup:

```bash
# Test work SSH connection
ssh -T github-work

# Test personal SSH connection
ssh -T github-personal

# Check Git config in work folder
cd ~/work/some-repo
git config user.email  # Should show work email

# Check Git config in personal folder
cd ~/personal/some-repo
git config user.email  # Should show personal email
```

## Alternative: Using Git URLs

If you prefer, you can also change remote URLs for existing repositories:

```bash
# For work repos
git remote set-url origin git@github-work:company/repo-name.git

# For personal repos
git remote set-url origin git@github-personal:username/repo-name.git
```

## Folder Structure Example

```
~/
├── work/
│   ├── project1/
│   └── project2/
├── personal/
│   ├── my-blog/
│   └── side-project/
└── .gitconfig
```

This setup ensures that:
- Work repositories automatically use your work SSH key and email
- Personal repositories automatically use your personal SSH key and email
- No manual switching between accounts required
- Each folder maintains its own Git identity


---

### User

im getting this error:
git@github.com: Permission denied (publickey)


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The user is getting a "Permission denied (publickey)" error. This is a common SSH authentication issue when setting up multiple GitHub accounts. Let me provide a systematic troubleshooting approach to help them resolve this.

The error suggests that either:
1. The SSH key isn't properly added to GitHub
2. The SSH key isn't being used correctly
3. There's an issue with the SSH agent
4. The SSH config isn't set up correctly
5. They might be using the wrong host in their git commands

I should provide a step-by-step debugging process.
</details>

This error indicates an SSH authentication issue. Let's troubleshoot step by step:

## 1. Check SSH Agent and Keys

First, verify your SSH agent has the keys loaded:

```bash
# Check if SSH agent is running
ssh-add -l

# If no keys are listed or agent isn't running, start it and add keys
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal

# Verify keys are added
ssh-add -l
```

## 2. Test SSH Connection

Test each SSH host separately:

```bash
# Test work connection
ssh -T github-work

# Test personal connection  
ssh -T github-personal

# If above fail, try with verbose output to see what's happening
ssh -vT github-work
```

## 3. Verify SSH Config

Check your `~/.ssh/config` file:

```bash
cat ~/.ssh/config
```

Ensure it looks like this:

```bash
# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Personal GitHub account  
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
```

## 4. Check Public Key on GitHub

Verify your public keys are added to the correct GitHub accounts:

```bash
# Display your public keys
cat ~/.ssh/id_ed25519_work.pub
cat ~/.ssh/id_ed25519_personal.pub
```

**Important**: 
- Copy the work public key and add it to your work GitHub account
- Copy the personal public key and add it to your personal GitHub account

## 5. Check File Permissions

Ensure correct permissions on SSH files:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519_work
chmod 600 ~/.ssh/id_ed25519_personal
chmod 644 ~/.ssh/id_ed25519_work.pub
chmod 644 ~/.ssh/id_ed25519_personal.pub
```

## 6. Debug Common Issues

### Issue A: Using wrong host in git commands

❌ **Wrong:**
```bash
git clone git@github.com:username/repo.git
```

✅ **Correct:**
```bash
# For work repos
git clone git@github-work:company/repo.git

# For personal repos
git clone git@github-personal:username/repo.git
```

### Issue B: Key not added to correct GitHub account

- Make sure the work public key is in your **work** GitHub account
- Make sure the personal public key is in your **personal** GitHub account

### Issue C: SSH agent issues on different systems

**On macOS**, add this to your `~/.ssh/config`:
```bash
Host *
    UseKeychain yes
    AddKeysToAgent yes
```

**On Linux**, you might need to add keys to agent on each session:
```bash
# Add to ~/.bashrc or ~/.zshrc
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519_work
    ssh-add ~/.ssh/id_ed25519_personal
fi
```

## 7. Test with Verbose Output

If still having issues, run with verbose output to see exactly what's failing:

```bash
ssh -vvv -T github-work
```

Look for lines like:
- `Offering public key: ...` (should show your key being offered)
- `Authentication succeeded` (should appear if working)
- Any error messages about key loading or authentication

## 8. Alternative: Test with Direct Key Specification

If SSH config isn't working, test by specifying the key directly:

```bash
ssh -i ~/.ssh/id_ed25519_work -T git@github.com
ssh -i ~/.ssh/id_ed25519_personal -T git@github.com
```

Let me know what output you get from the verbose SSH test (`ssh -vT github-work`) and I can help you pinpoint the exact issue!


---

### User

in my personal folder when i try to push a change its asking for username


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The user is getting prompted for username when trying to push changes in their personal folder. This typically happens when:

1. The remote URL is set to HTTPS instead of SSH
2. The SSH configuration isn't working properly
3. The remote URL is using the wrong SSH host

Let me provide a comprehensive solution to check and fix this issue.
</details>

This happens when your repository is configured to use HTTPS instead of SSH, or the SSH host isn't set up correctly. Let's fix this:

## 1. Check Current Remote URL

First, see what remote URL your repository is using:

```bash
cd ~/personal/your-repo
git remote -v
```

You'll likely see something like:
```
origin  https://github.com/username/repo-name.git (fetch)
origin  https://github.com/username/repo-name.git (push)
```

## 2. Change Remote URL to SSH

Change the remote URL to use your SSH host:

```bash
# Replace with your actual username and repo name
git remote set-url origin git@github-personal:username/repo-name.git

# Verify the change
git remote -v
```

You should now see:
```
origin  git@github-personal:username/repo-name.git (fetch)
origin  git@github-personal:username/repo-name.git (push)
```

## 3. Test SSH Connection First

Before pushing, make sure your SSH connection works:

```bash
ssh -T github-personal
```

You should see:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

## 4. Try Pushing Again

Now try to push your changes:

```bash
git push origin main
# or whatever your branch name is
```

## 5. If You Have Multiple Repositories

If you have multiple personal repositories, you can update them all:

```bash
# Find all git repositories in personal folder
find ~/personal -name ".git" -type d

# For each repository, update the remote URL
cd ~/personal/repo1
git remote set-url origin git@github-personal:username/repo1.git

cd ~/personal/repo2
git remote set-url origin git@github-personal:username/repo2.git
```

## 6. Automate URL Conversion (Optional)

You can create a script to convert all HTTPS URLs to SSH:

```bash
#!/bin/bash
# Save as convert-to-ssh.sh

find ~/personal -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    echo "Processing: $(pwd)"
    
    # Get current remote URL
    current_url=$(git remote get-url origin)
    
    # Check if it's HTTPS GitHub URL
    if [[ $current_url == https://github.com/* ]]; then
        # Extract username/repo from HTTPS URL
        repo_path=$(echo $current_url | sed 's|https://github.com/||' | sed 's|\.git$||')
        new_url="git@github-personal:$repo_path.git"
        
        echo "  Changing: $current_url"
        echo "  To: $new_url"
        
        git remote set-url origin "$new_url"
    fi
done
```

Run it with:
```bash
chmod +x convert-to-ssh.sh
./convert-to-ssh.sh
```

## 7. Verify Git Configuration

Also check that your personal folder is using the correct Git config:

```bash
cd ~/personal/your-repo
git config user.name
git config user.email
```

Should show your personal name and email.

## 8. For New Repositories

When cloning new personal repositories, always use the SSH host:

```bash
# ❌ Don't do this
git clone https://github.com/username/repo.git

# ✅ Do this instead
git clone git@github-personal:username/repo.git
```

## 9. Quick Fix Script

Here's a one-liner to fix the current repository:

```bash
# Run this in your personal repository folder
git remote set-url origin $(git remote get-url origin | sed 's|https://github.com/|git@github-personal:|' | sed 's|\.git$|.git|')
```

After making these changes, you should be able to push without being prompted for username/password. The SSH key authentication will handle everything automatically.

Try these steps and let me know if you're still getting prompted for credentials!


---

### User

in a repo inside personal folder , when I try to push it is using the ssh user of my work account

ERROR: Permission to SahilMahale/configs.git denied to sahil-mahale_mcgraw.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The error shows that the repository is trying to use the work SSH key (sahil-mahale_mcgraw) to access a personal repository (SahilMahale/configs.git). This suggests that:

1. The SSH configuration might not be set up correctly
2. The repository might be using the wrong SSH host
3. The SSH agent might be defaulting to the wrong key

The error "Permission denied to sahil-mahale_mcgraw" indicates that the work SSH key is being used, but the personal repository doesn't have access to that key - it needs the personal SSH key.

Let me provide a comprehensive solution to debug and fix this issue.
</details>

The error shows that your personal repository is trying to use your work SSH key (`sahil-mahale_mcgraw`) instead of your personal key. Let's fix this:

## 1. Check Current Remote URL

```bash
cd ~/personal/configs  # or whatever your repo is called
git remote -v
```

## 2. Fix the Remote URL

The remote URL should use your personal SSH host:

```bash
# Change this to use github-personal host
git remote set-url origin git@github-personal:SahilMahale/configs.git

# Verify the change
git remote -v
```

## 3. Test SSH Connection for Personal Account

```bash
# This should authenticate as your personal account
ssh -T github-personal
```

You should see:
```
Hi SahilMahale! You've successfully authenticated, but GitHub does not provide shell access.
```

If you see your work username instead, there's an SSH configuration issue.

## 4. Debug SSH Key Selection

Check which key is being used:

```bash
# Test with verbose output
ssh -vT github-personal
```

Look for lines like:
- `Offering public key: /home/user/.ssh/id_ed25519_personal`
- Should NOT show your work key being offered

## 5. Fix SSH Config (if needed)

Ensure your `~/.ssh/config` is correct:

```bash
cat ~/.ssh/config
```

Should look like:
```bash
# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
```

**Important**: The `IdentitiesOnly yes` is crucial - it prevents SSH from trying other keys.

## 6. Clear SSH Agent and Re-add Keys

Sometimes the SSH agent gets confused:

```bash
# Clear all keys
ssh-add -D

# Add keys back in specific order (personal first for default)
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work

# Verify
ssh-add -l
```

## 7. Test Again

```bash
# Test SSH connection
ssh -T github-personal

# Try pushing
git push origin main
```

## 8. Alternative: Force Specific Key for This Push

If you need a quick fix, you can specify the key directly:

```bash
# Push using specific SSH key
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_personal" git push origin main
```

## 9. Check Git Configuration

Verify your Git config in this folder:

```bash
cd ~/personal/configs
git config user.name    # Should show personal name
git config user.email   # Should show personal email
```

## 10. Ultimate Debug: Test Key Access

Test each key directly against your personal repo:

```bash
# Test work key (should fail)
ssh -i ~/.ssh/id_ed25519_work -T git@github.com

# Test personal key (should succeed)
ssh -i ~/.ssh/id_ed25519_personal -T git@github.com
```

## 11. Check GitHub Settings

Verify on GitHub:
- Your personal account has the personal public key added
- Your work account does NOT have access to the personal repository

## 12. Quick Fix Script

Here's a script to fix all personal repositories:

```bash
#!/bin/bash
# Fix all personal repos

find ~/personal -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    echo "Fixing: $(pwd)"
    
    # Get current remote URL
    current_url=$(git remote get-url origin)
    echo "Current URL: $current_url"
    
    # Extract repo path and fix URL
    if [[ $current_url == *"github.com"* ]]; then
        repo_path=$(echo $current_url | sed 's|.*github.com[:/]||' | sed 's|\.git$||')
        new_url="git@github-personal:$repo_path.git"
        
        echo "New URL: $new_url"
        git remote set-url origin "$new_url"
        
        # Test the connection
        echo "Testing SSH connection..."
        ssh -T github-personal
    fi
    echo "---"
done
```

The key issue is that your repository is not using the `github-personal` SSH host, so it's defaulting to the first available SSH key (your work key). Make sure to update the remote URL to use `git@github-personal:` instead of `git@github.com:`.

Try these steps and let me know what the output of `ssh -T github-personal` shows!


---

### User

it worked after clearing the keys but now in the same terminal window , I'm not able to push to a work repo


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The user cleared the SSH keys and re-added them, which fixed the personal repo issue. But now they can't push to a work repo from the same terminal window. This is likely because:

1. The SSH agent is now using the personal key by default since it was added first
2. The work repo might not be configured with the correct SSH host
3. There might be an issue with the SSH key order or configuration

I need to help them:
1. Check the work repo's remote URL
2. Ensure it's using the github-work host
3. Test the work SSH connection
4. Make sure both keys are properly loaded and the SSH config is working
</details>

This is happening because when you cleared and re-added the keys, the SSH agent is now defaulting to the personal key (since you added it first). Let's fix the work repo:

## 1. Check Work Repo Remote URL

```bash
cd ~/work/your-work-repo
git remote -v
```

## 2. Update Work Repo to Use Correct SSH Host

The work repo should use `github-work` host:

```bash
# Update to use work SSH host
git remote set-url origin git@github-work:company/repo-name.git

# Verify the change
git remote -v
```

## 3. Test Work SSH Connection

```bash
ssh -T github-work
```

Should show your work username:
```
Hi sahil-mahale_mcgraw! You've successfully authenticated, but GitHub does not provide shell access.
```

## 4. Verify Both Keys Are Loaded

```bash
ssh-add -l
```

Should show both keys loaded.

## 5. Test Both SSH Hosts

```bash
# Test personal (should show SahilMahale)
ssh -T github-personal

# Test work (should show sahil-mahale_mcgraw)
ssh -T github-work
```

## 6. Try Pushing to Work Repo

```bash
cd ~/work/your-work-repo
git push origin main
```

## 7. If Still Having Issues - Check SSH Config Order

Your `~/.ssh/config` should have `IdentitiesOnly yes` for both hosts:

```bash
cat ~/.ssh/config
```

Should look like:
```bash
# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
```

## 8. Alternative: Better Key Loading Order

You can re-order the keys so the work key is loaded first (if you work more with work repos):

```bash
# Clear and re-add in different order
ssh-add -D
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal

# Verify
ssh-add -l
```

## 9. Debug Work SSH Connection

If work SSH isn't working, debug with verbose output:

```bash
ssh -vT github-work
```

Look for:
- Which key is being offered
- Authentication success/failure messages

## 10. Fix All Work Repositories

If you have multiple work repositories, update them all:

```bash
# Find and fix all work repos
find ~/work -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    echo "Fixing work repo: $(pwd)"
    
    current_url=$(git remote get-url origin)
    echo "Current URL: $current_url"
    
    if [[ $current_url == *"github.com"* ]]; then
        repo_path=$(echo $current_url | sed 's|.*github.com[:/]||' | sed 's|\.git$||')
        new_url="git@github-work:$repo_path.git"
        
        echo "New URL: $new_url"
        git remote set-url origin "$new_url"
    fi
    echo "---"
done
```

## 11. Quick Test Both Accounts

Create a simple test script:

```bash
#!/bin/bash
echo "Testing SSH connections..."

echo "Personal account:"
ssh -T github-personal

echo "Work account:"
ssh -T github-work

echo "Checking git configs..."
echo "In personal folder:"
cd ~/personal && git config user.email

echo "In work folder:"
cd ~/work && git config user.email
```

## 12. The Key Point

The main issue is that **each repository must use the correct SSH host in its remote URL**:

- **Work repos**: `git@github-work:company/repo.git`
- **Personal repos**: `git@github-personal:username/repo.git`

Never use `git@github.com:` directly - always use your configured SSH hosts (`github-work` or `github-personal`).

Try updating your work repo's remote URL and let me know if you can push to both accounts now!


---

### User

how to automatically load these ssh keys to ssh agent when I open a fresh terminal window


---

### Assistant (claude-4-sonnet-reasoning)

<details>
<summary>Reasoning</summary>

The user wants to automatically load their SSH keys to the SSH agent when they open a fresh terminal window. This is a common issue when working with multiple SSH keys. There are several approaches depending on the operating system and shell they're using. I'll provide solutions for different scenarios.

The main approaches are:
1. Adding commands to shell startup files (.bashrc, .zshrc, etc.)
2. Using SSH config with AddKeysToAgent
3. Using keychain (for persistent SSH agent)
4. Platform-specific solutions (macOS Keychain, systemd on Linux)

I should provide multiple solutions since I don't know their exact setup.
</details>

Here are several ways to automatically load SSH keys when opening a new terminal:

## Method 1: Shell Startup Script (Most Common)

Add this to your shell config file (`.bashrc`, `.zshrc`, `.bash_profile`, etc.):

```bash
# For bash: ~/.bashrc
# For zsh: ~/.zshrc
# For macOS bash: ~/.bash_profile

# Function to start SSH agent and load keys
start_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        # Start SSH agent if not running
        eval "$(ssh-agent -s)"
    fi
    
    # Check if keys are already loaded
    if ! ssh-add -l >/dev/null 2>&1; then
        # Load keys if not already loaded
        ssh-add ~/.ssh/id_ed25519_work
        ssh-add ~/.ssh/id_ed25519_personal
        echo "SSH keys loaded successfully!"
    fi
}

# Call the function
start_ssh_agent
```

## Method 2: SSH Config with Auto-Add (Recommended)

Edit `~/.ssh/config` to automatically add keys when used:

```bash
# Add this at the top of ~/.ssh/config
Host *
    AddKeysToAgent yes
    UseKeychain yes  # macOS only - stores in Keychain

# Work GitHub account
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Personal GitHub account
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
```

Then load the keys once:
```bash
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```

## Method 3: Using Keychain (Linux/Unix)

Install and use `keychain` for persistent SSH agent:

```bash
# Install keychain
# Ubuntu/Debian:
sudo apt install keychain

# CentOS/RHEL:
sudo yum install keychain

# macOS:
brew install keychain
```

Add to your shell config (`.bashrc`/`.zshrc`):

```bash
# Initialize keychain
eval $(keychain --eval --agents ssh id_ed25519_work id_ed25519_personal)
```

## Method 4: macOS Specific (Keychain Integration)

For macOS, you can store keys in the system Keychain:

1. **Update SSH config** (`~/.ssh/config`):
```bash
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentitiesOnly yes

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work

Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
```

2. **Add keys to Keychain**:
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_work
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
```

## Method 5: Systemd User Service (Linux)

Create a systemd user service to manage SSH agent:

1. **Create service file** (`~/.config/systemd/user/ssh-agent.service`):
```ini
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
ExecStartPost=/usr/bin/ssh-add ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal

[Install]
WantedBy=default.target
```

2. **Enable and start**:
```bash
systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service
```

3. **Add to shell config**:
```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

## Method 6: Advanced Shell Script

Create a more robust script in your shell config:

```bash
# Add to ~/.bashrc or ~/.zshrc

# SSH Agent Management
ssh_agent_setup() {
    local SSH_AGENT_PID_FILE="$HOME/.ssh/ssh-agent.pid"
    local SSH_AGENT_SOCK_FILE="$HOME/.ssh/ssh-agent.sock"
    
    # Check if agent is already running
    if [ -f "$SSH_AGENT_PID_FILE" ] && [ -S "$SSH_AUTH_SOCK" ]; then
        local PID=$(cat "$SSH_AGENT_PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            # Agent is running, check if keys are loaded
            if ! ssh-add -l >/dev/null 2>&1; then
                ssh-add ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal
            fi
            return
        fi
    fi
    
    # Start new agent
    eval "$(ssh-agent -s)" > /dev/null
    echo $SSH_AGENT_PID > "$SSH_AGENT_PID_FILE"
    
    # Load keys
    ssh-add ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal
    echo "SSH agent started and keys loaded"
}

# Call the function
ssh_agent_setup
```

## Method 7: Simple One-liner

For a quick solution, add this to your shell config:

```bash
# Simple auto-load
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519_* 2>/dev/null
```

## Recommended Approach

I recommend **Method 2** (SSH Config with auto-add) combined with **Method 1** (basic shell script) for the best experience:

1. **Update `~/.ssh/config`** with `AddKeysToAgent yes`
2. **Add this to your shell config**:

```bash
# Auto-start SSH agent and load keys
if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add ~/.ssh/id_ed25519_work ~/.ssh/id_ed25519_personal 2>/dev/null
fi
```

This approach:
- ✅ Works on all platforms
- ✅ Loads keys automatically
- ✅ Doesn't reload if already loaded
- ✅ Minimal overhead

Choose the method that best fits your operating system and preferences!


---
