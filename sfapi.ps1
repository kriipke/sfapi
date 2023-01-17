function sfapi {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[string]
		$Uri,

		[Parameter()]
		[ValidateSet('GET','POST','PUT')]
		[String]
		$HttpRequestType = "GET",

		[Parameter()]
		[ValidateSet('jq','jiq')]
		[String]
		$DisplayMethod = 'jq',

		[Parameter()]
		[String]
		$CredentialFilePath = "$PSScriptRoot/config/default.json"
	)

	process {

		# 
		#  AUTHENTICATE TO API
		#

		# Load credentials from JSON file (default stored in ./config/default.json)
		$api_creds = (Get-Content -Raw -Path $CredentialFilePath | ConvertFrom-Json)

		$body = @{
			grant_type = "password"
			client_id = $api_creds.api_token_id
			client_secret = $api_creds.api_token_secret
			username = $api_creds.user_login
			password = $api_creds.user_password
		}

		$params = @{
			Method = "POST"
			Uri = "https://$($api_creds.subdomain).sharefile.com/oauth/token"
			Body = $body
			ContentType = 'application/x-www-form-urlencoded'
		}

		$auth_response = (Invoke-RestMethod @params)
 		$api_endpoint = "https://$($auth_response.subdomain).$($auth_response.apicp)/sf/v3" 

		$auth_token_type = $auth_response.token_type
		$auth_token = $auth_response.access_token
		$auth_http_header_value = "$((Get-Culture).TextInfo.ToTitleCase($auth_token_type)) $auth_token"

		# 
		#  EXECUTE API CALL PROVIDED BY USER
		#

		$headers = @{
			"Authorization" = $auth_http_header_value
		}
	
		$params = @{
			Method = $HttpRequestType.ToUpper()
			Uri = "$api_endpoint/$(($Uri).TrimStart('/'))"
			ContentType = 'application/x-www-form-urlencoded'
			Headers = $headers
		}

		$query_response = (invoke-restmethod @params | convertto-json)

		#  This function will attempt to output the response from the API call in the
		#   most user-friendly way possible, trying (in this order):
		#
		# 	1. jid
		# 		* interactive, terminal-based JSON navigator
		# 		* https://github.com/simeji/jid
		#
		# 	2. jq
		# 		* used here just for colorizing JSON output
		# 		* https://stedolan.github.io/jq/ 
		#
		# 	3. powershell
		# 	  * simply prints the JSON as Powershell would print any other string
		#
		#  NOTE: both jid & jq are single binary files you can drop in your $PATH and
		#         they are both extremely useful & worth downloading, in this context
		#         jid is *especially* useful
		
		
		switch($DisplayMethod)
		{
			'jq' {
				if(get-command 'jq') {
					$query_response | jq -C
				}
				elseif(Test-Path -Path "$PSScriptRoot/bin/jq-win64.exe" -PathType Leaf) {
					$query_response | & $PSScriptRoot/bin/jq-win64.exe -C
				}
				else {
					echo "Error: Cannot display results using chosen output method ($DisplayMethod)."
					echo "Printing output as Powershell string."
					$query_response
				}
			}
			'jiq' {
				if(get-command 'jiq') {
					$query_response | jiq
				}
				elseif(Test-Path -Path "$PSScriptRoot/bin/jiq_windows_am64.exe" -PathType Leaf) {
					$query_response | & $PSScriptRoot/bin/jiq_windows_am64.exe
				}
				else {
					echo "Error: Cannot display results using chosen output method ($DisplayMethod)."
					echo "Printing output as Powershell string."
					$query_response
				}
			}
		}

	}
}
