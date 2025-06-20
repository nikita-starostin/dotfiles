# 24th april

## Julia - secure reader desktop application
Should be done by 9th of May

For the now product management have just seen:
1. app wireframes - p10 ui and desktop application
2. Phil showed 
  * he took the new secure card
  * for the new secure card he is using the special desktop reader
    * the desktop application should be opened
    * desktop reader to laptop
    * user put secure card into the desktop reader
    * user can roll keys on the P10 and save new keys | P10 -> Desktop Reader
    * user can transfer pax lock binding token | Pax Lock -> P10
  * after that user can manager the secure card on the p10 UI

30 days for testing - involgin p10 ui, scanning card, new app

## Techical tasks
1. Create application for QA
  - need to create an installer for windows, to publish the app https://paxton.atlassian.net/browse/PSR1-207
2. QA should be able to sign in to the APP and see if failed to find desktop reader
  - need to implement authentication 
    - question do we need to provide feedback is user system enginer or have not permissions
  - need to run firmware check if success to locate DTR, to tell the user if DTR is not connected
  - sync firmware
  - download new keys
    - download if required (question for Alex how to determine is that required, I would say always because currently it is stored in memory)
    - download API endpoint is implemented
    - send new keys to DTR (question for Phil)
4. they can press roll keys
  - roll keys
  - download new keys
    - download if required (question for Alex how to determine is that required, I would say always because currently it is stored in memory)
    - download API endpoint is implemented
    - send new keys to DTR (question for Phil)
5. thet can press pax lock binding (not ready, not clear what is going on)

## TO be done
By 9th of may e2e to be started

### Enable Secure Mode on the P10 UI
  ? https://paxton.atlassian.net/browse/PSR1-168 Localization 
  https://paxton.atlassian.net/browse/PSR1-174 Enable secure mode via UI
    check is Proceed button hidden when nor secure tokens, currently it is shown and enabled with warning
    waiting for Alex

  https://paxton.atlassian.net/browse/PSR1-172 Enable sucure mode UI
    waiting for verification from Alex onto one question

  https://paxton.atlassian.net/browse/PSR1-173 Enable secure mode UI
    clarifications from Alex

  https://paxton.atlassian.net/browse/PSR1-175 Enable secure mode UI
    clarification from Alex
  review https://paxton.atlassian.net/browse/PSR1-194 UI part with wireframes
  #### TBD
  https://paxton.atlassian.net/browse/PSR1-181 Create a link to download installer
    waiting for alex
  review https://paxton.atlassian.net/browse/PSR1-140 Remove backups
  deleted https://paxton.atlassian.net/browse/PSR1-141 Optional restore insecure mode
  #### TODO
  https://paxton.atlassian.net/browse/PSR1-176 Check what sites are in secure mode
    waiting for Ale
  https://paxton.atlassian.net/browse/PSR1-183 Additional check t prevent enabling of secure mode with net2
    waiting for Alex
  https://paxton.atlassian.net/browse/PSR1-195 Show information about failed to enable secure mode controllers
    waiting for Alex

### devops part
  https://paxton.atlassian.net/browse/PSR1-207 Create installer for windows
  https://paxton.atlassian.net/browse/PSR1-154 Installer for mac
  https://paxton.atlassian.net/browse/PSR1-153 translations

https://paxton.atlassian.net/browse/PSR1-208 Login button works
  https://paxton.atlassian.net/browse/PSR1-185 read keys from the encrypted file
  https://paxton.atlassian.net/browse/PSR1-138 Save keys in encrypted way in Device service, currently stored in memory
  https://paxton.atlassian.net/browse/PSR1-136 Create keys in device service when they are not exists
  https://paxton.atlassian.net/browse/PSR1-186 Create MQTT subscription to provide for door readers
  https://paxton.atlassian.net/browse/PSR1-187 notifications about keys
  https://paxton.atlassian.net/browse/PSR1-143 GET endpoint for retriveing keys 

https://paxton.atlassian.net/browse/PSR1-209 Roll keys button
  https://paxton.atlassian.net/browse/PSR1-171 Ability to roll keys on regular basis
  https://paxton.atlassian.net/browse/PSR1-144 POST endpoint for roll keys

https://paxton.atlassian.net/browse/PSR1-210 Pax lock button
  https://paxton.atlassian.net/browse/PSR1-180 Bind pax lock to the new site
  https://paxton.atlassian.net/browse/PSR1-182 Add instruction about PaxLock when secure mode enabled to the P10 UI
  https://paxton.atlassian.net/browse/PSR1-191 DTR App required to save pax lock token

## Ready for selling
https://paxton.atlassian.net/browse/PSR1-177 buy smth 
https://paxton.atlassian.net/browse/PSR1-178 buy smth





# 23rd april

## [Desktop Reader Application PSR1-35](https://paxton.atlassian.net/browse/PSR1-35)

### Done

* [Setup initial ui](https://paxton.atlassian.net/browse/PSR1-165)
* [Add initial hardware code](https://paxton.atlassian.net/browse/PSR1-166)
* [Add support for logging](https://paxton.atlassian.net/browse/PSR1-167)
* [Add support for localization](https://paxton.atlassian.net/browse/PSR1-168)
* [Run p10 app](https://paxton.atlassian.net/browse/PSR1-169)
* [Implement wireframes](https://paxton.atlassian.net/browse/PSR1-170)

### To Do





# 14th april - 19th april


## 1. prepare small test build with using one of Phil's apis, to proove that desktop can talk to readers
1.1. investigate and prepare build for windows 11
1.2. Alex will provide firmware file that should be added to the build, so the build app should be able to reference that file
1.2. Call sync firmware on login - if sync success show buttons, otherwiser error message

## 2. epic https://paxton.atlassian.net/browse/PSR1-133

https://paxton.atlassian.net/browse/PSR1-136 create site key in device service when if key doesn't exist
  * more info here https://paxton.atlassian.net/wiki/spaces/SD/pages/4744478725/Paxton10+Server+Secure+Site+Key+Design
      Create a SiteKeyService in Dms.Device.Service
  ```
      // site key set should be a single time generated and cached
      // when there is not site key set, it will be generated
      // currently it will be stored in memory and regenerated every time device service started
      interface SiteKeySet {
         // checks if cache exists, if yes, download from cache, otherwise create 1 key
         void Init();
         void AddNew();
         string ReadLast();
         string Read4Last();
      }

      interface IAmCreateForDesktopReader {
         // will provide a created earlier key or generate the new one and cache if not exists
         // it returns 4 last keys in the format that suits best for the desktop reader
         string GetKey(); 

         // add new key to the key set
         void RollKeys();
      }
    ```
## epic https://paxton.atlassian.net/browse/PSR1-135
Bind process talks from web service to device service
1. https://paxton.atlassian.net/browse/PSR1-143 endpoint for retrieving site key set
2. https://paxton.atlassian.net/browse/PSR1-144 endpoint for rolling the key
3. https://paxton.atlassian.net/browse/PSR1-191 endpoint for saving one string into DmsCredential
   with new type `PaxlockBindingToken`

