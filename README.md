# `sfapi` - a Powershell wrapper for the ShareFile API

## Introduction

This repository provides a PowerShell function, `sfapi`, to interact with the Sharefile API programmatically in a way that does NOT require OAuth authnetication like the [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) SDK does. 

* The [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) tool requires users to authenticate via OAuth using a browser window that pops up during use allowing the user to authenticate using a username, password, and whatever 2FA methods they have enabled on their ShareFile account (SMS by default). Alternatively, this is a function which sources credentials, one of which is an [application specific password](https://support.citrix.com/article/CTX277723/generate-an-applicationspecific-password) from a file stored locally in JSON allowing the user to use the `sfapi` function in _other PowerShell scripts meant to run in automation routines_.

* Another reason you might want to use this tool instead of [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) is because the Citrix authored PowerShell SDK for ShareFile makes a lot of assumptions about the type of work you wish to do with the SDK and therefore does not give you full access to the API. This tool, on the other hand, allows you to make ANY call possible within the ShareFile API. For a list of available API entites and possible queries please visit https://api.sharefile.com/docs/ and expand the "API Entities" section on the left-hand navigation column.

## Getting Started

0. If you have 2FA enabled on your ShareFile account, the API will fail to authenticate. In order to maintain 2FA on your ShareFile account while using the API you need to generate an [application specific password](https://support.citrix.com/article/CTX277723/generate-an-applicationspecific-password) in the ShareFile "User Settings" for your account. You will give this as the password in the JSON file containing your credentials (`.\config\default.json`).
1. Drop this directory in your ShareFile account under `Personal Folders`.
2. Add the following to (a) `$PROFILE.CurrentUserAllHosts` if you wish to use it from the command line or (b) the top of your script if you wish to user it from within another script:

    `. "C:\path\to\sfapi\sfapi.ps1"`

3. Rename `.\config\default.json.example` to `.\config\default.json` 
4. Replace the values in your newly renamed `.\config\default.json` with your creds.

## Usage

Use the new `sfapi` by typing out the command name and putting whatever would go at the end of `https://yoursubdomain.sf-api/sf/v3/`. The precediing `/` is optional.

For example:

    sfapi "/Users"

or

    sfapi "Users"

are both equivalent to calling `https://yoursubdomain.sf-api.com/sf/v3/Users`

to list all use,sers, or

    sfapi "Users(10f3ca20-f68d-8bb2-a7f3-56adfa0ad60f0)"

is equivalent to calling `https://yoursubdomain.sf-api.com/sf/v3/Users(10f3ca20-f68d-8bb2-a7f3-56adfa0ad60f0)`

If you are using the command in a script you will want to probably store the output in a variable like this:

	$ShareFileUsers = $( sfapi "Users" )

### Options

By default the function will output the API response in the form of a PowerShell object. If you would like the output in the form of a JSON string you can give the following command line option:

	sfapi -OutputMethod 'json' "Users"
