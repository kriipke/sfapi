# `sfapi` - a Powershell wrapper for the ShareFile API

## Getting Started

0. If you have 2FA enabled on your ShareFile account, the API will fail to authenticate. In order to maintain 2FA on your ShareFile account while using the API you need to generate an "app-specific password" in the ShareFile "User Settings" for your account. You will give this as the password in the JSON file containing your credentials (`.\config\default.json`).
1. Drop this directory in your ShareFile account under `Personal Folders`.
2. Add the following to `$PROFILE.CurrentUserAllHosts`:

	. 'S:\Personal Folders\sfapi\sfapi.ps1'

3. Rename `.\config\default.json.example` to `.\config\default.json`
4. Repalce the values in `.\config\default.json`
 
 