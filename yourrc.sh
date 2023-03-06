function mfa {
  local main_profile="YOUR_NON_MFA_USER_PROFILE" # <- update this with your normal user with the long lived access keys 
  local profile_name="YOUR_PROFILE_FOR_TEMP_CREDS" #prod/nonprod etc <- Update this with the local profile name of your temp iam creds
  local mfa_device_arn="arn:aws:iam::12345678901:mfa/YOUR_USER_NAME" # <- Update this with your account id, and your username

  aws configure set profile $main_profile
  local credentials_command="aws sts get-session-token --serial-number ${mfa_device_arn} --token-code"
  local mfa_token="$1"
  local output=$(eval "${credentials_command} ${mfa_token}")
  if [ $? -eq 0 ]; then
      local access_key_id=$(echo "${output}" | jq -r '.Credentials.AccessKeyId')
      local secret_access_key=$(echo "${output}" | jq -r '.Credentials.SecretAccessKey')
      local session_token=$(echo "${output}" | jq -r '.Credentials.SessionToken')
      aws configure --profile ${profile_name} set aws_access_key_id ${access_key_id}
      aws configure --profile ${profile_name} set aws_secret_access_key ${secret_access_key}
      aws configure --profile ${profile_name} set aws_session_token ${session_token}
      echo "Temporary profile ${profile_name} updated with new credentials."
      aws configure set profile ${profile_name}

      echo "Default profile set to ${profile_name}."
  else
      echo "Error updating temporary profile with new credentials."
  fi

  aws configure set profile $profile_name
}