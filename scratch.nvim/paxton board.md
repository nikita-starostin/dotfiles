# Daily

prepare for demo
fix internal apps bad request body is being ignored 

sell observability + tests, resell in the itra, maybe smbd will need premium quality of service health
  - also nice for automation teams

## SFRF
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
 
