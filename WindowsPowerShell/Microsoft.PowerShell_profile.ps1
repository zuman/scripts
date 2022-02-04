Set-Variable -Name server -Value zh-server
Function ddl { ssh $server }
Function gaa { git add --all }
Function grmt { git remote set-url origin zap@{$server}:~/pipelines/alpha/mytrade }
Function gs { git status }
Function mc { memcached }
Function uu { ubuntu run }
