#!/bin/bash

if [[ -z "$MW_AWS_ACCESS_KEY_ID" || -z "$MW_AWS_SECRET_ACCESS_KEY" || -z "$MW_AWS_DEFAULT_REGION" ]]; then
  echo_warning "Aws access key settings not set, skipping"
else
  export AWS_ACCESS_KEY_ID=$MW_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$MW_AWS_SECRET_ACCESS_KEY
  export AWS_DEFAULT_REGION=$MW_AWS_DEFAULT_REGION
  unset AWS_SESSION_TOKEN

  if [[ -z "$MW_AWS_ASSUME_ROLE_ACCOUNT" || -z "$MW_AWS_ASSUME_ROLE_ROLE" ]]; then
    echo_warning "Aws assume role settings not set, skipping"
  else
    USERDATA="$(aws --output json iam get-user)"
    USERARN="$(echo $USERDATA | jq -r .User.Arn)"
    USERMFAOPTS="$(echo $USERDATA | jq -r .User.MFAOptions)"

    if [[ -z "$USERARN" ]]; then
        echo_error "$0 error: unable to determine AWS IAM user.  Did you run 'aws configure'?" > \
            /dev/stderr
        exit 128
    fi

    IAMUSER="$(basename $USERARN)"
    ACCOUNT="$(echo $USERARN | cut -d: -f5)"
    ROLEARN="arn:aws:iam::$MW_AWS_ASSUME_ROLE_ACCOUNT:role/$MW_AWS_ASSUME_ROLE_ROLE"
    MFAARN="arn:aws:iam::$ACCOUNT:mfa/$IAMUSER"

    echo -n "Enter MFA token code for $MFAARN: "
    read -s MFACODE
    echo ""

    RESP="$(aws --region $AWS_DEFAULT_REGION sts assume-role \
        --role-arn $ROLEARN \
        --role-session-name assumption-$IAMUSER-$(date +%s) \
        --serial-number $MFAARN --token-code $MFACODE 2> /dev/null)"

    AKI="$(echo $RESP | jq -r .Credentials.AccessKeyId)"

    if [[ -z "$AKI" ]]; then
        echo "Failure." > /dev/null
        exit 129
    fi
            
    SAK="$(echo $RESP | jq -r .Credentials.SecretAccessKey)"
    ST="$(echo $RESP | jq -r .Credentials.SessionToken)"

    export AWS_ACCESS_KEY_ID="$AKI"
    export AWS_SECRET_ACCESS_KEY="$SAK"
    export AWS_SESSION_TOKEN="$ST"
  fi
fi

