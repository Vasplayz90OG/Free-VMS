#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}       ARIZNODES 1-CLICK DEPLOYER       ${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}This will automatically create a GitHub repo and install the Leapfrog VPS engine.${NC}"
echo ""

read -p "Enter your GitHub Username: " GH_USER
read -s -p "Enter your GitHub Personal Access Token (Needs 'repo' & 'workflow' scopes): " GH_TOKEN
echo ""
read -p "Enter a name for your new VPS repository (e.g., my-free-vps): " REPO_NAME

echo -e "\n${CYAN}[1/3] Creating repository '$REPO_NAME'...${NC}"

CREATE_RES=$(curl -s -w "%{http_code}" -o /dev/null -X POST -H "Authorization: token $GH_TOKEN" -H "Accept: application/vnd.github.v3+json" https://api.github.com/user/repos -d "{\"name\":\"$REPO_NAME\", \"private\": true}")

if [ "$CREATE_RES" != "201" ]; then
    echo -e "${RED}❌ Failed to create repo. Check your token/permissions.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Repository created successfully!${NC}"
echo -e "${CYAN}[2/3] Injecting Leapfrog VPS Engine...${NC}"

# This is the workflow with 6-hour uptime AND auto-restart cron
YML_CONTENT=$(cat <<'EOF'
name: Leapfrog VPS

on:
  workflow_dispatch:
   schedule:
    - cron: '0 */6 * * *'

permissions:
  contents: write

jobs:
  Build-VPS:
    runs-on: ubuntu-latest
    steps:
      - name: Setup Tmate VPS
        run: |
          sudo apt-get update
          sudo apt-get install -y tmate
          tmate -S /tmp/tmate.sock new-session -d
          tmate -S /tmp/tmate.sock wait tmate-ready
          TMATE_SSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
          echo "====================================="
          echo "YOUR VPS SSH LINK IS:"
          echo "$TMATE_SSH"
          echo "====================================="
          
      - name: Keep Alive (Max 5h 50m)
        run: |
          echo "VPS is running..."
          sleep 350m
EOF
)

ENCODED_YML=$(echo "$YML_CONTENT" | base64 -w 0)

PUSH_RES=$(curl -s -w "%{http_code}" -o /dev/null -X PUT -H "Authorization: token $GH_TOKEN" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$GH_USER/$REPO_NAME/contents/.github/workflows/vps.yml -d "{\"message\":\"Initial VPS Engine Commit\", \"content\":\"$ENCODED_YML\"}")

if [ "$PUSH_RES" != "201" ]; then
    echo -e "${RED}❌ Failed to inject workflow file.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ VPS Engine injected successfully!${NC}"

echo -e "${CYAN}[3/3] Starting your VPS...${NC}"
sleep 5
curl -s -X POST -H "Authorization: token $GH_TOKEN" -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$GH_USER/$REPO_NAME/actions/workflows/vps.yml/dispatches -d '{"ref":"main"}' > /dev/null

echo -e "${GREEN}✅ VPS Startup Triggered!${NC}"
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  DEPLOYMENT COMPLETE!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Your VPS is booting up right now."
echo "Go here to get your SSH link (wait 30 seconds and click the yellow dot):"
echo -e "${YELLOW}https://github.com/$GH_USER/$REPO_NAME/actions${NC}"
echo ""
echo -e "${YELLOW}NOTE: The VPS will auto-restart every 6 hours!${NC}"
echo "When it restarts, you will need to check the Actions logs again to get your NEW SSH link."
