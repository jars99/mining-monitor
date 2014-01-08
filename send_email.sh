SUBJECT=$1;
MESSAGE=$2;
echo "$MESSAGE" |mailx -s "$SUBJECT" <email to text address>
