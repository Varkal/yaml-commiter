#!/bin/sh

set -e

usage() {
  echo "Usage: yaml-commit [ -u | --url URL ] 
                        [ -n | --name NAME ] 
                        [ -k | --key KEY ] 
                        [ -v | --value VALUE ]
                        [ -U | --user URL ] 
                        [ -E | --email URL ]  
                        [ -f | --file FILE ]"
  exit 2
}

push() {
  echo "[4/4] - Pushing..."
  STATUS=$(git push || echo "error")
  while [ "$STATUS" == "error" ]; do
    echo "Push failed, retrying..."
    git pull --rebase
    STATUS=$(git push || echo "error")
  done
}

PARSED_ARGUMENTS=$(getopt -a -o u:n:k:v:f:U:E: --long url:,name:,key:,value:,file:,user:,email: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

USER_NAME="YamlCommiter"
USER_EMAIL="yamlcommiter@example.com"

eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -u | --url)
    REPO_URL="$2"
    shift 2
    ;;
  -n | --name)
    REPO_NAME="$2"
    shift 2
    ;;
  -k | --key)
    KEY="$2"
    shift 2
    ;;
  -v | --value)
    VALUE="$2"
    shift 2
    ;;
  -f | --file)
    FILE_NAME="$2"
    shift 2
    ;;
  -U | --user)
    USER_NAME="$2"
    shift 2
    ;;
  -E | --email)
    USER_EMAIL="$2"
    shift 2
    ;;
  # -- means the end of the arguments; drop this, and break out of the while loop
  --)
    shift
    break
    ;;
  # If invalid options were passed, then getopt should have reported an error,
  # which we checked as VALID_ARGUMENTS when getopt was called...
  *)
    echo "Unexpected option: $1 - this should not happen."
    usage
    ;;
  esac
done

if [ -z ${REPO_URL+x} ]; then
  echo "url is unset"
  usage
fi
if [ -z ${REPO_NAME+x} ]; then
  echo "name is unset"
  usage
fi
if [ -z ${KEY+x} ]; then
  echo "key is unset"
  usage
fi
if [ -z ${VALUE+x} ]; then
  echo "value is unset"
  usage
fi
if [ -z ${FILE_NAME+x} ]; then
  echo "file is unset"
  usage
fi

echo "[1/4] - Cloning $REPO_URL into $REPO_NAME..."
git clone $REPO_URL $REPO_NAME
cd $REPO_NAME
echo "[2/4] - Setting $KEY = $VALUE into $FILE_NAME..."
yq e -i "$KEY = \"$VALUE\"" $FILE_NAME
echo "[3/4] - Commiting with $USER_NAME<$USER_EMAIL>..."
git -c "user.name=$USER_NAME" -c "user.email=$USER_EMAIL" commit -am ":rocket: set $KEY to $VALUE in $FILE_NAME"
push;
