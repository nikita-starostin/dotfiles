---
description: >
  Prepares e2e tests for the PR
mode: subagent
tools:
  read: true
  glob: true
  grep: true
  bash: true
  write: false
  edit: false
---

Analyze provided changes. Write doen in yml format the e2e spec that will help to test validity of the app. Provide typescript file which describes the model for the state.

Example of the spec:
```yaml
e2e-spec:
  actions:
    - trigger_block
    - trigger_warned_declined
    - trigger_warned_accepted
    - trigger_monitor
  flow:
    metrics_changes_as_expected:
      init:
        - reset scan tables
        - sign in
        - assert_metrics_state (all empty)
      blocked_phase:
        - trigger_block
        - assert_metrics_state 
        - trigger_block
        - trigger_block
        - assert_metrics_state
      warned_accepted_phase:
        - trigger_warned_accepted
        - assert_metrics_state 
        - trigger_warned_accepted
        - trigger_warned_accepted
      warned_declined_phase:
        - assert_metrics_state 
        - trigger_warned_declined
        - assert_metrics_state 
        - trigger_warned_declined
        - trigger_warned_declined
        - assert_metrics_state 
      monitored_phase:
        - assert_metrics_state 
        - trigger_monitor
        - assert_metrics_state 
        - trigger_monitor
        - trigger_monitor
        - assert_metrics_state 
```


Example of e2e spec state model in ts:

```ts
interface MetricsSpecState = {
  promtsBlocked: string; // types here similar to can retrieced with raw playwright selector from the webpage
  // ...
  usersTable: { // the table represent multiple items and have totals and pages
    totals: {total: string}, // continue to use string, because values will be collected with the playwright
    pagination: {currPage: string, totalPages: string},
    tableItemms: Array<{
      userId: string;
      userName: string;
      totalCount
    }>;
  },
}
```

That spec has one flow which check that all metrics are being changed as expected. It will be used to write e2e tests, the pseudo code for such e2e tests provided below. From it, you can also see how the actions, state, flow are used for code generations and better understand it's purpose.

Pseudo code

```ts

const actions = {
  triggerBlock: (page: Page, state: SpecState) => {

  } // playwright implementation of action trigger_block
}

const collectState = async (page: Page): SpecState => { // collects state from the UI
  let state = {
    promptsBlocked: '',
    usersTable: { 
      totals: {total: ''},
      pagination: {currPage: '', totalPages: ''},
      tableItems: [],
    },
  };

  await step('collect metrics from page "/dashboard"', () => {
    // playwright code to go to /dashboard and wait loading 
    await step('collect prompts blocked', () => {
      state.promptsBlocked = // playwright code to retrieve the promptsBlocked value
    });
  })

  await step('collect metrics from page "/dashboard/drilldown"', () => {
    // playwright code to go to /dashboard/drilldown and wait loading 
    await step('collect users table', () => {
      state.userTable.totals.total = // playwright code to retrieve the total value
      // fill other state field for users total
    });
  })

  return state;
}

const expectState = (state: SpecState, expected: SpecState) => {
  expect.equal(state.blockedPrompts, expected.blockedPrompts);
}

describe('<ticket name>', () => {
  let specState = { // state that is being tested, contains values that can be asserted again raw values grabbed from UI
    blockedPrompts: '0', 
    // ...
  };

  it('metrics changed as expected', ({page}) => {
    const stepAssertState = (message: string) => {
      const uiState = await collectState(page);
      expectState(specState, uiState);
    }

    await step('init', () => {
      await step('reset scan table', () => { /* code to reset scan tables */})
      await step('sign in', () => { /* code to sign in */})
      await stepAssertState('assert state all empty');
    });

    await step('blocked_phase', () => {
      await step('trigger block 1st time', () => {
        specState = await actions.triggerBlock(page, state);
      })
      await stepAssertState('assert state after 1st time trigger block');
      await step('trigger block 2nd time', () => { 
        specState = await actions.triggetBlock(page, state);
      })
      await step('trigger block 3rd time', () => { 
        specState = await actions.triggetBlock(page, state);
      })
      await stepAssertState('assert state after 3 time blocked');
      // ...
    });

    // ...
  });
}
```
