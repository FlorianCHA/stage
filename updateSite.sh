date=`date`
message="$1 date : $date"
git add *
messageCommit = echo $message
git commit -m echo $messageCommit
git push
