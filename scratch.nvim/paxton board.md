# App Instances

src code ==build==> build 

How to identify which token type is passed?

I can try to validate token against different set of configuration params.

config

build + config ==run==> running web app

Issue: 
    the required configuration could be known only on the request execution,
    so that leads to complicated code

Suggestion:
    move task of determening 

Convinence, I guess managing and setting up the the rules on the b2c is easier for one server.
Copy paste, etc.
However, on the other side adding the new apps will be harder 
  - since more knowledge will be required.
  - almost impossible to test properly
There is an alternate solution.

Pros:
  Easier to support MFA codebase
    1. simpler code - less logic, less conditions checks, straightforward
    2. easy to extend
    3. less code
    4. simpler app config

  Better performance
    1. better perfomance
    2. if any issues in one app, it won't be reflected in other apps
    3. independent scaling
    4. easier to track monitoring for different apps

Cons:
1. Two separate deployes
2. The routing module becomes the critical point instead 

