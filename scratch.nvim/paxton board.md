# Agenda

1. The B2C journey has to be started on the same domain where application is hosted.
2. What is for PCAC api?
3. 


# Admin portal numbers
699 monitors
708 panels
97241 calls this month
24544 calls answered this month
78507 calls last month
17237 calls answered last month

######

Passkeys & MFA - Proposals - Confluence
Passkeys &amp; MFA
Updated 4 months ago
 
https://github.com/Paxton-Access/solo-backend
 
tools/E2E 
"run.ps1 -Update"

# Prepare for meeting

1. Passkey sign in page is hosted on the azure function app, that access is protected by custom policy, so only users with non expired magic link can open that
2. The function saves the token into the generated response as global js variable
3. The page tries to get creds, when no creds create and get creds.
4. for verification and get creds the token from global will be used
4.1. handle missing pass keys
4.2. handle sync of user data between server and pass keys
5. the token expiration time is short
6. all endpoints leave in the same azure function

## questions
1. currently the sole and entry leaves in the same service - the entry required some claims, that should be populated, how that will be done with solo sign in?
2. how the msal sign in will be done once passkey retrived and validated?
3. How many users in solo? To understand what size of the storage required to store users

## Suggestion
Create a dotnet api container authenticated by magic link auth with next functions:
1. webauthn/handeResponse - to handle response from navigator.credentials.get
2. webauthn/registerResponse - to handle response from navigator.credentials.create
3. webauthn/page - to return page that will work with passkey provider and perform sync of the data

The function also can talk to other services and use existing infratrusture of the entry cloud

The function app can store all the information inside of cosmos container

# Implementation

https://web.dev/articles/passkey-registration
https://developers.google.com/identity/passkeys/developer-guides/server-registration

## 1. Check for compatibilty
```js
// Availability of `window.PublicKeyCredential` means WebAuthn is usable.  
// `isUserVerifyingPlatformAuthenticatorAvailable` means the feature detection is usable.  
// `isConditionalMediationAvailable` means the feature detection is usable.  
if (window.PublicKeyCredential &&  
    PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable &&  
    PublicKeyCredential.isConditionalMediationAvailable) {  
  // Check if user verifying platform authenticator is available.  
  Promise.all([  
    PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable(),  
    PublicKeyCredential.isConditionalMediationAvailable(),  
  ]).then(results => {  
    if (results.every(r => r === true)) {  
      // Display "Create a new passkey" button  
    }  
  });  
}  
```

## 2. Fetch required information from the backend to call navigator.credentials.

```js
// Example `PublicKeyCredentialCreationOptions` contents
{
  challenge: *****, // a server generated challenge in ArrayBuffer, a random string 16+ bytes, e.g. weMLPOSx1VfSnMV6uPwDKbjGdKRMaUDGxeDEUTT5VN8
  rp: { // relying party
    name: "Example",  // deprecated, included for compatability
    id: "example.com", // if an RP's origin is https://login.example.com:1337, the RP ID can be either login.example.com or example.com. If the RP ID is specified as example.com, the user can authenticate on login.example.com or on any subdomains on example.com
  },
  user: {
    id: *****, // user id, OID, in entry case, it should be permanent, should not contain any personal information
    name: "john78", // a unique identifier that should be recognizable, by user, will be an email, it is displayed in the account selector
    displayName: "John", // optional, if not passed, use empty string, more user friendly user name, that should not be unique and could be used in some places 
  },
  pubKeyCredParams: [{ // Specifies the RP (relying party) supported public-key algorithms. We recommend setting it to [{alg: -7, type: "public-key"},{alg: -257, type: "public-key"}]. This specifies support for ECDSA with P-256 and RSA PKCS#1 and supporting these gives complete coverage.
    alg: -7, type: "public-key"
  },{
    alg: -257, type: "public-key"
  }],
  excludeCredentials: [{ // array of already registered creds, used to prevent registration of same device twice
    id: *****,
    type: 'public-key',
    transports: ['internal'], // should contain results of calling `getTransports()` during registration of each credential
  }],
  authenticatorSelection: {
    authenticatorAttachment: "platform", // Set this to "platform" along with hint: ['client-device'] if this passkey creation is an upgrade from a password for example in a promotion after a sign-in. "platform" indicates that the RP wants a platform authenticator (an authenticator embedded to the platform device) which does not prompt, for example, to insert a USB security key. The user has a simpler option to create a passkey.
    requireResidentKey: true, // set to true, a discoverable credential (resident key) stores user information to the passkey and lets user select an account
    userVerification: "preferred", // Indicates whether a user verification using the device screen lock is "required", "preferred" or "discouraged". The default is "preferred", which means the authenticator may skip user verification. Set this to "preferred" or omit the property.
  }
}
```

It is recommended to fetch data from server, the data should be an ArrayBuffer encoded with Base64URL:
https://developers.google.com/identity/passkeys/developer-guides/server-registration

### Sample 1 from docs

```js
import {
  generateRegistrationOptions,
  verifyRegistrationResponse,
  generateAuthenticationOptions,
  verifyAuthenticationResponse
} from '@simplewebauthn/server';
import { isoBase64URL } from '@simplewebauthn/server/helpers';

router.post('/registerRequest', csrfCheck, sessionCheck, async (req, res) => {
  const { user } = res.locals;
  // Ensure you nest verification function calls in try/catch blocks.
  // If something fails, throw an error with a descriptive error message.
  // Return that message with an appropriate error code to the client.
  try {
    // `excludeCredentials` prevents users from re-registering existing
    // credentials for a given passkey provider
    const excludeCredentials = [];
    const credentials = Credentials.findByUserId(user.id);
    if (credentials.length > 0) {
      for (const cred of credentials) {
        excludeCredentials.push({
          id: isoBase64URL.toBuffer(cred.id),
          type: 'public-key',
          transports: cred.transports,
        });
      }
    }

    // Generate registration options for WebAuthn create
    const options = await generateRegistrationOptions({
      rpName: process.env.RP_NAME,
      rpID: process.env.HOSTNAME,
      userID: user.id,
      userName: user.username,
      userDisplayName: user.displayName || '',
      attestationType: 'none',
      excludeCredentials,
      authenticatorSelection: {
        authenticatorAttachment: 'platform',
        requireResidentKey: true
      },
    });

    // Keep the challenge in the session
    req.session.challenge = options.challenge;

    return res.json(options);
  } catch (e) {
    console.error(e);
    return res.status(400).send({ error: e.message });
  }
});
```

### Sample 2 by AI
```js
// sample nodejs ipmlementation
const crypto = require('crypto');

// 1. Create the object
const challengeObject = {
  userName: 'qwe',
  challenge: crypto.randomBytes(32).toString('base64url'), // Random challenge
    // Add other fields if needed (e.g., challenge, rpId)
};

// 2. Convert to JSON -> ArrayBuffer
const jsonString = JSON.stringify(challengeObject);
const arrayBuffer = Buffer.from(jsonString, 'utf-8'); // Node.js Buffer is a subclass of Uint8Array

// 3. Encode as Base64URL (WebAuthn-compatible)
const base64url = arrayBuffer.toString('base64')
  .replace(/\+/g, '-')
  .replace(/\//g, '_')
  .replace(/=/g, '');

// 4. Send to frontend (e.g., via API response)
res.json({ challenge: base64url });

// sample fronend handling
// Fetch the challenge from the server
const response = await fetch('/api/get-challenge');
const { challenge } = await response.json();

// Decode Base64URL -> ArrayBuffer
function base64urlToArrayBuffer(base64url) {
      const padding = '='.repeat((4 - (base64url.length % 4)) % 4);
      const base64 = (base64url + padding).replace(/-/g, '+').replace(/_/g, '/');
      const binaryString = atob(base64);
      const bytes = new Uint8Array(binaryString.length);
      for (let i = 0; i < binaryString.length; i++) {
            bytes[i] = binaryString.charCodeAt(i);
          }
  return bytes.buffer;
}

const decodedArrayBuffer = base64urlToArrayBuffer(challenge);
const decodedObject = JSON.parse(new TextDecoder().decode(decodedArrayBuffer));
console.log(decodedObject); // { userName: 'qwe' }

// Use in WebAuthn (e.g., navigator.credentials.create())
const publicKeyCredential = await navigator.credentials.create({ publicKey: decodedOpject });
```

## 3 create passkey
```js
// Invoke WebAuthn to create a passkey.
const credential = await navigator.credentials.create({
  publicKey: options
});
```

## 4 send passkey to backend
After the user is verified using the device's screen lock, a passkey is created and the promise is resolved returning a PublicKeyCredential object to the frontend.

The promise can be rejected for different reasons. 
You can handle these errors by checking the Error object's name property:
- InvalidStateError: A passkey already exists on the device. 
    No error dialog will be shown to the user. 
    The site shouldn't treat this as an error. 
    The user wanted the local device registered and it is.
- NotAllowedError: The user has canceled the operation.
- AbortError: The operation has been aborted.
- Other exceptions: Something unexpected happened. The browser shows an error dialog to the user.

The public key credential object contains the following properties:
- id: A Base64URL encoded ID of the created passkey. 
    This ID helps the browser to determine whether a matching passkey is in the device upon authentication. 
    This value must be stored in the database on the backend.
- rawId: An ArrayBuffer version of the credential ID.
- response.clientDataJSON: An ArrayBuffer encoded client data.
- response.attestationObject: An ArrayBuffer encoded attestation object. 
    This contains important information such as an RP ID, flags and a public key.
- authenticatorAttachment: Returns "platform" when this credential is created on a passkey capable device.
- type: This field is always set to "public-key".

```js
// Encode and serialize the `PublicKeyCredential`.
const credential = await navigator.credentials.create({
  publicKey: options
});

const _result = credential.toJSON();
const result = JSON.stringify(_result);

// Encode and send the credential to the server for verification.  
const response = await fetch('/webauthn/registerResponse', {
  method: 'post',
  credentials: 'same-origin',
  body: result
});
```

# 5 save passkeys to the backend
Save the credential
After receiving the public key credential on the backend, we recommend using a server-side library or a solution instead of writing your own code to process a public-key credential.

You can then store the information retrieved from the credential to the database for future use.

The following list includes recommended properties to save:
- Credential ID: The credential ID returned with the public key credential.
- Credential name: The name of the credential. Name it after the passkey provider it's created by which can be identified based on the AAGUID.
- User ID: The user ID used to create the passkey.
- Public key: The public key returned with the public key credential. This is required to verify a passkey assertion.
- Creation date and time: Record the date and time of the passkey creation. This is useful to identify the passkey.
- Last used date and time: Records the last date and time when the user used the passkey to sign in. This is useful to determine which passkey the user has used (or not used).
- AAGUID: A unique identifier of the passkey provider.
- Backup Eligibility flag: true if the device is eligible for passkey synchronization. This information helps users identify syncable passkeys and device-bound (not syncable) passkeys on the passkey management page.
Follow more detailed instructions at Server-side passkey registration

```js
// Encode and serialize the `PublicKeyCredential`.
const _result = credential.toJSON();
const result = JSON.stringify(_result);

// Encode and send the credential to the server for verification.  
const response = await fetch('/webauthn/registerResponse', {
  method: 'post',
    credentials: 'same-origin',
      body: result
      });
...
```
# Signal if registration failed
If a passkey registration fails, it may cause confusion to the user. 
If there's a passkey in the passkey provider and available for the user, but the associated public key isn't stored to the server side, 
sign-in attempts using the passkey will never succeed and it's hard to troubleshoot. Make sure to let the user know if that is the case.

To prevent such a condition, you can signal an unknown passkey to the passkey provider using the Signal API. 
By calling PublicKeyCredential.signalUnknownCredential() with an RP ID and a credential ID, 
the RP can inform the passkey provider that the specified credential has been removed or does not exist. 
It's up to the passkey provider how to deal with this signal, but if supported, the associated passkey is expected to be removed.

```
// Detect authentication failure due to lack of the credential
if (response.status === 404) {
  // Feature detection
  if (PublicKeyCredential.signalUnknownCredential) {
    await PublicKeyCredential.signalUnknownCredential({
      rpId: "example.com",
      credentialId: "vI0qOggiE3OT01ZRWBYz5l4MEgU0c7PmAA" // base64url encoded credential ID
    });
  } else {
    // Encourage the user to delete the passkey from the password manager nevertheless.
    ...
  }
}
```

## Key points
1. Check if passkeys supported
2. Check if PublicKeyCredential supports signalUnkonwnCredential, or handle cred not found on backend in other way

# Passkeys

Google doc - https://developers.google.com/identity/passkeys/
 
Google sample - https://developers.google.com/codelabs/passkey-form-autofill#0

confluence - https://paxton.atlassian.net/wiki/spaces/PROP/pages/4906418187/Passkeys+MFA
 
 
## Overview
Overview of the magic email sample app:

PCAC API
Takes an email address for an existing user
Uses signing key #1 to generate a JWT, with the pcac api as the issuer (an intermediate signing token)
Sends an email to the user, which contains the JWT as an id_token_hint param

B2C Custom Policy
Loads the page
decodes the JWT in the id_token_hint and validates the issuer is the pcac api 
checks the user exists and is active in B2C
generates a B2C JWT Token for the user
Redirects to the final destination, as configured in the app registration
 
A self-signed signing certificate has been used for this example.  This exists in both the PCAC API, and, within B2C

[Notionally, the PCAC API can behave as the OIDC service, however, it would not read the "keys" from the signed message until I swapped it to B2C is the OIDC endpoint, and, had "knowledge" of the cert and private key.  So I removed the OIDC implementation from the sample project, however, its in the GIT project below]

https://github.com/azure-ad-b2c/samples/tree/master/policies/invite#using-b2c-to-generate-the-metadata-endpoints
https://github.com/azure-ad-b2c/samples/tree/master/policies/sign-in-with-magic-link

I created the following Policy keys (as unsure who was using the others, appears to be noone).  Part of the creation allows the upload of the signing key #1


3. B2C_1A_TRUSTFRAMEWORKBASE.xml policy has been uploaded with the above items referenced

```
<CryptographicKeys>
    <Key Id="issuer_secret" StorageReferenceId="B2C_1A_MagicLinkTokenSigningKeyContainer" />
    <Key Id="issuer_refresh_token_key" StorageReferenceId="B2C_1A_MagicLinkTokenEncryptionKeyContainer" />
</CryptographicKeys>
```

B2C_1A_SIGNIN_WITH_MAGIC_LINK.xml policy has been uploaded
Changes:
Set the provider to be B2C for OIDC

<Item Key="METADATA">https://paxtoninternalapps.b2clogin.com/PaxtonInternalApps.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1A_SIGNIN_WITH_MAGIC_LINK</Item>
 

Set the issuer to be either online or debug, depending on environment

           <!--LIVE <Item Key="issuer">https://paxpcacb2cmagicid.azurewebsites.net/</Item> -->
             <Item Key="issuer">https://localhost:44326/</Item>
 

Amended the TechnicalProfile Id="AAD-UserReadUsingEmailAddress"  RaiseErrorIfClaimsPrincipalDoesNotExist to true, otherwise incorrect / non existing users threw exception instead of graceful error 

  <TechnicalProfile Id="AAD-UserReadUsingEmailAddress">
                <Metadata>
              <Item Key="RaiseErrorIfClaimsPrincipalDoesNotExist">true</Item>
   

Amended claims to include

            <!--Sample: add optional claims to read from the directory-->
            <OutputClaim ClaimTypeReferenceId="accountEnabled"/>
 


signing key #1 was created using following PS, then exporting from local machine store. 
Note: Any cert generation tool can be used as long as the extensions are set correctly.

 

NOTE: Included code to allow Log Analytics Workspace debugging of policies.  See commented code "For Log Analytics support:" in this file

I created the following App Registration to support this
B2C_1A_SIGNIN_WITH_MAGIC_LINK
24593058-2bd8-4e40-a990-0beed55464cf

NOTE:  read the "Using this in your Production Application" section.  The sample is a POC only

The authentication libraries create a state when the authentication flow begins from your application. This sample creates a raw link to the Azure AD B2C Policy, also referred to as a "Run Now" link. This type of link is not suitable for your production application instance and should only be used to test the sample.
For a Production scenario, the link containing the the id_token_hint should point to your application, https://myapp.com/redeem?hint=<id_token_hint value>. The application should have a valid route to handle a query parameter contatining the id_token_hint. The App should then use the authentication library to start an authentication to the AAD B2C Policy Id for which this id_token_hint is due to be consumed at. The library will contain a method to add query parameters to the authentication request. See the docuementation for the library in use to implement this.
The authentication library will then build the final authentication link, with the id_token_hint appended as part of a query parameter. This will now be a valid authentication request and your user will be redirected to the Azure AD B2C policy from your Application. Your application will be able to handle the response from Azure AD B2C properly.


For Single Page Applications library guidance. https://docs.microsoft.com/en-us/azure/active-directory-b2c/enable-authentication-spa-app-options#pass-id-token-hint

AADB2C.MagicLink.WebApi.zip

For .Net Applications library guidance.  https://learn.microsoft.com/en-us/azure/active-directory-b2c/enable-authentication-web-application-options#pass-an-id-token-hint
 
 
