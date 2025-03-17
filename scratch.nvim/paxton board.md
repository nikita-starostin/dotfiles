# Daily


## Desktop Reader


DekstopReader - pluggable device
P10 Application - server on-premise, running somewhere on localhost
Pax Lock - pluggable device, door reader

Feature "Secure Readers" in the P10 Application user can enable 
  - that will delete insecure tokens from P10 database
  - create **first** site id and store it securely on the P10 server

Secure Desktop Reader requires "Secure Readers" to be enabled
Secure Readers ask for keyset, that can contain up to 4 site ids.

Desktop Reader Application is a bridge between "Secure Readers" and "P10 Appication"

User will input url to P10 application - we can ask for endpoint to get 401 if it is available on the network
User will provide login and password
Press login

On the main page load
- will check for firmware on the desktop reader if it is not expected it will install the expected firmware threw the HID interface
 - firmware update is an edge, that almost should never happen
 - if failed to update firmware, show notification about failure, user may try again
 - it is possible that the desktop reader can dead

- will check for server version
 - if P10 Server version is wrong, user will see notification and he will need to update P10 server manually

- will check for version keys
 - if update required it will be run and updated
 - if update failed show error screen with message and button "try again"

Once checks passed we show UI with two buttons
1. Roll keys - grab keys from P10 app put via HID interface in Secure Reader
2. Pax lock binding token - setup token for authentication and authorization in the Pax Lock


What are technical requirements?
    Windows and MacOS
    Ui should be separated from Hardware as much as possible
    Customer need to be download and install
    There is a firmware writing all the Pax Lock and Desktop Reader
    Check interface and see if I can setup that

What are business requirements?
What are support requirements?
What are resource capabilities?
What are technical limitations?

MaUI 
 - I can spend time to learn the new videos
 - 

I would use tauri instead of MAUI, because I need to spend time onto learning MAUI api and MAUI distribution details.

In both cases I need to spend time to learn, I think I will be faster with tauri, because I am already pretty familiar with JS ecosystem.

I know that tauri allow me to be use common html-css-js approach, which by far the proved with time in UI as best option.

Also, tauri has better documentation and provides more control, so it should be easier to find an expert to clarify smth.

It is also possible to tauri to invoke C# executable that would put responses into file.

I would spend some time building same thing onto both frameworks and see which suits better.

Let me please to lead that project


# SFRF
SOLO wireframes https://xd.adobe.com/view/f774e9bb-bee3-4d47-9b18-77390366fb6c-a227/
https://paxton.atlassian.net/browse/SFSR-1339 systems page
https://paxton.atlassian.net/browse/SFSR-1340 systems > app users and system details
https://paxton.atlassian.net/browse/SFSR-1341 systems > devices

questions for solo:
- what should be localizable?
- what is about permissions?
- what is about account status?
- what is consolidation of invoice?
- is it possible to add users?
- does it makes sense to show entry portal without solo for entry users only? It could be for free because of feature flags.
- are more products going to be added? 
- why buttons add devices/remove devices on the costs page?

# Retro
Edge cases for invoices are not looking great from UI perspective:
1. empty dropdown with invoices just not clickabe
2. it is possible to meet de-sync issue when paying an invoice because failure to talk to entry
  - when starting payment session get better response from IA
  - create next fields in the invoice: `paidInStripe`, `paidInStripeUpdatedAt`, `lastUpdatedAt`,
    use that three fields to show processing state for invoice and avoid selection on the UI
 
