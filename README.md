 # ⚡ Free-VMS 1-Click Deployer

                                        <img width="156" height="28" alt="image" src="https://github.com/user-attachments/assets/97b5bfcf-7ebb-4d52-8789-4c023763faa2" />
 
                                                             

Warning: This script automates the creation of a GitHub repository to host a free VPS. To avoid risking your main GitHub account, it is highly recommended to use a burner/alternate GitHub account.

🧠 What is this?
Free-VMS Deployer is a 1-click bash script that automatically provisions a free Linux VPS using GitHub Actions. When you run the command, it uses the GitHub API to create a new repository, injects the Leapfrog workflow, and boots up an Ubuntu environment that you can access via SSH.

No credit cards. No dedicated servers. Just pure cloud infrastructure automation.

🚀 Quick Start
Open your terminal (Linux/Mac, or Windows WSL/Termius) and paste this one command:

curl -s https://raw.githubusercontent.com/Vasplayz90/Free-VMS/main/deploy.sh | bash
The script will ask you for:

Your GitHub Username
Your GitHub Personal Access Token (see below)
A name for your new VPS repository
🔑 How to get a Personal Access Token
For the script to automatically create a repo for you, it needs a token.

Go to GitHub Settings -> Developer settings -> Personal access tokens -> Tokens (classic).
Click Generate new token (classic).
Give it a name (e.g., "Free-VMS").
Under "Select scopes", check the boxes for:
repo (Full control of private repositories)
workflow (Update GitHub Action workflows)
Click Generate token at the bottom.
Copy the token and paste it into the script when prompted.
🛠️ How It Works
API Authentication: The script takes your GitHub token and securely authenticates with the GitHub API.
Repository Creation: It creates a brand new, private repository under your account.
Workflow Injection: It encodes the vps.yml Leapfrog Engine into Base64 and pushes it to the new repository via the GitHub Contents API.
Action Trigger: It sends a workflow_dispatch API request to instantly boot up the Ubuntu runner.
SSH Access: The runner installs tmate, creates an SSH tunnel, and prints the connection link in your GitHub Actions logs.
⚙️ After Deployment
Once the script says "Deployment Complete", do this:


Click on the running workflow.
Wait 30 seconds and look at the logs for the ssh xxxxxxx@nyc1.tmate.io link.
Paste that link into your SSH client. You are now inside your VPS!
⚠️ Limitations & Features
Auto-Leapfrog: The VPS auto-restarts every 6 hours to bypass GitHub's execution time limits.

How to run by one cmd  📜

Auto-Backup: Any files saved in the repository folder are automatically committed and pushed to GitHub every 30 minutes.
No Persistent Storage: When the runner restarts, files outside the repository folder are destroyed. Make sure to keep your files in the repo folder.
Docker Access: The runner has sudo privileges, meaning you can install Docker and spawn containers inside your VPS!

How to run by one cmd  📜

📎 ``` curl -s https://raw.githubusercontent.com/Vasplayz90/Free-VMS/main/deploy.sh | bash ```
