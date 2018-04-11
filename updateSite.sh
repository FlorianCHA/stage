date=`date`
messageCommit="$1 date : $date"
git add *
git commit -m "'$messageCommit'"
git push
