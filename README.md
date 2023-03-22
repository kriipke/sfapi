# `sfapi` - a Powershell wrapper for the ShareFile API

## Introduction

This repository provides a PowerShell function, `sfapi`, to interact with the Sharefile API programmatically in a way that uses OAuth "password grant" authentication unlike the [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) SDK. 

* The [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) tool does not allow users to authenticate via password grant with OAuth, and instead will, by default, use a browser window that pops up during use allowing the user to authenticate using a username, password, and whatever 2FA methods they have enabled on their ShareFile account (SMS by default). Instead, this is a function which sources credentials, one of which is an [application specific password](https://support.citrix.com/article/CTX277723/generate-an-applicationspecific-password) from a file stored locally in JSON allowing the user to use the `sfapi` function in _other PowerShell scripts meant to run in automation routines_.

* Another reason you might want to use this tool instead of [citrix/ShareFile-PowerShell](https://github.com/citrix/ShareFile-PowerShell) is because the Citrix authored PowerShell SDK for ShareFile makes a lot of assumptions about the type of work you wish to do with the SDK and therefore does not give you full access to the API. This tool, on the other hand, allows you to make ANY call possible within the ShareFile API. For a list of available API entites and possible queries please visit https://api.sharefile.com/docs/ and expand the "API Entities" section on the left-hand navigation column.

* The PowerShell code contained in this `sfapi` is relatively straight-forward should you decide to modify it. The ShareFile SDK has a much more complex code-base and for that reason does not lend well to tweaking or modifying, not is it meant to.

## Getting Started

0. If you have 2FA enabled on your ShareFile account, the API will fail to authenticate. In order to maintain 2FA on your ShareFile account while using the API you need to generate an [application specific password](https://support.citrix.com/article/CTX277723/generate-an-applicationspecific-password) in the ShareFile "User Settings" for your account. You will give this as the password in the JSON file containing your credentials (`.\config\default.json`). In order to authenticate with this tool you will need the following pieces of information handy:
	* Your organization's [ShareFile subdomain](https://support.citrix.com/article/CTX223556/how-to-create-or-edit-a-sharefile-subdomain)
	* API user's username (email)
	* API user's application specific password
	* API user's [client ID](https://api.sharefile.com/apikeys)
	* API user's [client secret](https://api.sharefile.com/apikeys)
1. Clone this repository in to a folder you would like to keep it in using: 
	git clone --depth 1 https://github.com/kriipke/sfapi.git
2. Navigate to the config folder with 
	`cd sfapi\config`
3. Rename or copy `default.json.example` to `default.json` with:
	`cp .\default.json.example .\default.json`
4. Replace the values in your newly renamed `.\config\default.json` with your creds from step 0.
5. Add the following to (a) `$PROFILE.CurrentUserAllHosts` if you wish to use it from the command line or (b) the top of your script if you wish to user it from within another script:

    `. "C:\path\to\sfapi\sfapi.ps1"`


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
