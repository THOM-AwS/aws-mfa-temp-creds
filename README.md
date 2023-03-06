# aws-mfa-temp-creds
automatically generate temp creds for your aws profile

1. Add in your profile that has your long lived access keys.
2. Add in your profile that you will use for MFA authenticated access
3. Add in your MFA device name from IAM
4. copy this code into your bashrc/zshrc

to call it `mfa 12345` at the cli. 

will require a new shell, or source of your bash file before it will work. 

