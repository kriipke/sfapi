function sfapi {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory, ValueFromPipeline)]
		[string]
		$Uri,

		[Parameter()]
		[ValidateSet('GET', 'POST', 'PUT')]
		[String]
		$HttpRequestType = "GET",


		[Parameter()]
		[ValidateSet('json', 'powershell')]
		[String]
		$OutputMethod = 'powershell',

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
			grant_type    = "password"
			client_id     = $api_creds.api_token_id
			client_secret = $api_creds.api_token_secret
			username      = $api_creds.user_login
			password      = $api_creds.user_password
		}

		$params = @{
			Method      = "POST"
			Uri         = "https://$($api_creds.subdomain).sharefile.com/oauth/token"
			Body        = $body
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
			Method      = $HttpRequestType.ToUpper()
			Uri         = "$api_endpoint/$(($Uri).TrimStart('/'))"
			ContentType = 'application/x-www-form-urlencoded'
			Headers     = $headers
		}

		$query_response = (invoke-restmethod @params )

		if ($OutputMethod -eq 'json') {
			return $( $query_response | convertto-json)
		}
		else {
			return $query_response
		}

	}
}
