# Daily
*blocked* tax code validation - 1h
  - *info needed* john tasker confirmation needed
  - *blocker* api not working again

*in progress* health service
    update admin portal - 2h
    run remix server - 4h, taken 6h

*to do* implement system page for solo - 2h

# TODO
Update code review ticket

## TaxCode
https://paxton.atlassian.net/browse/EAM-218 - I have added 1st comment from Oli - waiting for more
https://paxton.atlassian.net/browse/EAM-217 - same as EAM-218

## Other
https://paxton.atlassian.net/browse/EAM-85 - Jony responded
 - TBD - how to prepare repo for prod
 - TODO 
  - run a remix server in same container https://docs.docker.com/engine/containers/multi-service_container/

## SFRF
https://paxton.atlassian.net/browse/SFSR-1339 systems page
https://paxton.atlassian.net/browse/SFSR-1340 systems > app users and system details
https://paxton.atlassian.net/browse/SFSR-1341 systems > devices

# Retro
Edge cases for invoices are not looking great from UI perspective:
1. empty dropdown with invoices just not clickabe
2. it is possible to meet de-sync issue when paying an invoice because failure to talk to entry
  - when starting payment session get better response from IA
  - create next fields in the invoice: `paidInStripe`, `paidInStripeUpdatedAt`, `lastUpdatedAt`,
    use that three fields to show processing state for invoice and avoid selection on the UI
 
