export JIRA_URL="https://jira.devnet.klm.com"
export JIRA_NAME="T206002"

alias smokerecord='clear && yarn nx run e2e:record'
alias smokereplay='clear && yarn nx run e2e:replay'
alias smokeheadless='clear && yarn nx run e2e:headless'
alias fakesession='clear && yarn nx run fake-session:serve'

alias nxg='yarn nx g'
alias nxgm='yarn nx g module'
alias nxgc='yarn nx g @ngneat/spectator:spectator-component'
alias nxgs='yarn nx g @ngneat/spectator:spectator-service'
alias nxgd='yarn nx g @ngneat/spectator:spectator-directive'

alias apirequests="cd ~/Developer && mkdir -p mitm-files && cd mitm-files && mitmproxy --listen-port=8080 --set view_filter='!beacon & !pharos' --set console_focus_follow=true --set console_default_contentview='json'"

alias appstart='yarn nx run touchpoint-web:serve:ute3'
alias gqlstart='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost yarn nx run gql:serve:ute3'
alias gqlstartd='yarn nx run gql:serve:ute3'
alias serverstart='yarn nx run touchpoint-web:server:ute3'
alias exchangestart='yarn nx run exchange:serve:ute3'

alias gqlstartute2='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost yarn nx run gql:serve:ute2'
alias serverstartute2='yarn nx run touchpoint-web:server:ute2'

alias introspect='(cd apps/gql && yarn graphql:introspect)'

alias nxr='clear && yarn nx run'
