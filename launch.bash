#!/bin/sh 

# Library for Drawercli (launch.bash) by u0a316
# For more information:
# https://www.shellcheck.net/wiki/SC2034 -- online appears unused. Verify use...
# https://www.shellcheck.net/wiki/SC2002 -- Useless cat. Consider 'cmd < file...
#set -xv
history_filename="drawercli_history"
enable_history=0
export url="https://raw.githubusercontent.com/u0a316/ListMyApps/refs/heads/curl/app_activity.txt"

launch_RequireInternetConnection() {
    ping -c 1 google.com > /dev/null 2>&1
    return $?
    #&& return 0 || :
};
launch_CheckConection() {
if ! launch_RequireInternetConnection; then
    echo "Offline mode!"
    return 1
  else
    echo "Online mode!"
    return 0
fi
};
launch_ItSelf() {
 : || am start --user 0 -n com.termux/com.termux.app.TermuxActivity > /dev/null 3>&1;

};
launch_CheckConection;
if [ $? -eq 1 ]; then
  unset app
  app="$HOME/storage/shared/Documents/.listmyapps/app_activity.txt"
      online=false
      launch_App() {
        if [ $# -eq 0 ] || [ -z "$1" ]; then
          return
        fi 
       target_source="${app:-}"
        am start --user 0 -n "$(cat "$target_source" | awk -F '|' -v name="$1" 'tolower($1) ~ tolower(name) {print $2; exit}')"
      };
      launch_AppList() {
         target_source="${app:-}"
        cat "$target_source" | awk -F '|' '{print $1}'
      };
    else
      app="url"
      online=true
launch_App() {
  if [ $# -eq 0 ] || [ -z "$1" ]; then
    return
  fi
  target_url="${url:-}" 
    am start --user 0 -n "$(curl -sL "$target_url" | awk -F '|' -v name="$1" 'tolower($1) ~ tolower(name) {print $2; exit}')" 
};
launch_AppList() {
    eval "target_url=\$$app"
    curl -sL "$target_url" | awk -F '|' '{print $1}'
};
launch_Source() {
  curl -L "$url"
};

fi 

launch_Random() {
  numerof="$1"
  launch_App "$(launch_AppList  | sort --reverse --numeric-sort | shuf | head -n "$numerof" | fzf -0)"
};
launch_Main() {
  if [ $enable_history -eq 0 ]; then
  launch_App "$(launch_AppList  | sort --reverse --numeric-sort | fzf | tee -a ~/.${history_filename})";
  else
    launch_App "$(launch_AppList | sort --reverse --numeric-sort | fzf )";
  fi
};

#set +xv
