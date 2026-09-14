export JIRA_URL="https://jira.devnet.klm.com"
export JIRA_NAME="T206002"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias nxg='npm run nx -- g'
alias nxgm='npm run nx -- g module'
alias nxgc='npm run nx -- g @ngneat/spectator:spectator-component'
alias nxgs='npm run nx -- g @ngneat/spectator:spectator-service'
alias nxgd='npm run nx -- g @ngneat/spectator:spectator-directive'

alias apirequests="cd ~/Developer && mkdir -p mitm-files && cd mitm-files && mitmproxy --listen-port=8080 --set view_filter='!beacon & !pharos' --set console_focus_follow=true --set console_default_contentview='json' --mode upstream:http://127.0.0.1:8081 --ssl-insecure"

# UTE3
alias appstart='npm run nx -- run touchpoint-web:serve:ute3'
alias gqlstart='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost npm run nx -- run gql:serve:ute3'
alias exchangestart='npm run nx -- run exchange:serve:ute3'

# UTE2
alias appstartute2='npm run nx -- run touchpoint-web:serve:ute2'
alias gqlstartute2='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost npm run nx -- run gql:serve:ute2'
alias exchangestartute2='npm run nx -- run exchange:serve:ute2'

alias introspect='(cd apps/gql && npm run graphql:introspect)'

alias nxr='clear && npm run nx -- run'

alias mocksengine="mkdir -p ~/Developer/mitm/mocked-responses && mkdir -p ~/Developer/mitm/scripts && touch ~/Developer/mitm/scripts/save_responses.py && mitmdump -s ~/Developer/mitm/scripts/save_responses.py --listen-port 8081"
