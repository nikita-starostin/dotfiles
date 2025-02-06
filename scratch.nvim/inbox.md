# Shitty code 1 - express, typescript, locals

Shitty code - is code which support is hard, unpleasant and time overconsuming.

It is hard to tell about that, because of infinite variants of implementation

So I am going to show you samples in that series

Compare that, sample with express app locals, which is being set in two different places
with raw code, e.g.

```
// handlers.ts
handler1(req: Request, res: Response) {
    req.app.locals.isRunning = false;
    // ...
}

handler2(req: Request, res: Response) {
    req.app.locals.isRunning = true;
    // ...
}

handler3(req: Request, res: Response) {
    return req.app.locals.isRunning;
}
```

here easy to make a mistake when updating code, and that will be found just in runtime
and if the buggy place wasn't run in test, will be revialed in production

alternative is to create a single file for express state
```
// for example, server.state.ts
const isRunningKey = 'isRunning';

export function setIsRunning(req: Request, value: boolean) {
  req.app.locals[isRunningKey] = value;
}

export function getIsRunning(req: Request): boolean {
  return !!req.app.locals[isRunningKey];
}

// handlers
handler1(req: Request, res: Response) {
    setIsRunning(req, false);
}

handler2(req: Request, res: Response) {
    setIsRunning(req, true);
}

handler3(req: Request, res: Response) {
    return getIsRunning(req);
}
```

With that sample, 
1. it is harder to create a bug later when introducing changes
2. it is possible to cover with unit tests
3. there is type safety, everyone using isRunning app.locals, now operate on a boolean, instead of boolean | undefined
4. it is easier to find all places with find references ()

PS. Bonus link to the example with shitty code, that you can debug
PPS. It is also applied to architecture on larger scale as well
PPPS. That is a sample of architectural guideline decision on code

# Horror - what issues can be brought by deps

Imagine, you are working on a ticket. You close that and forget.
It was a ticket for writing script to generate some assets.

Three months later, you asked to regenerate them.

You run your script, but it fails. And now you have no idea, how to repair it.
Because you was using webpack (Pirate Cherep Icon)

# what is architecture in development

В широком смысле этого слова, архитектура - это медитация, это дао, это йога, это умение формировать реальность.
Обучение этому навыку проходит на протяжении всей жизни.

В разработке - это умение формировать реальность программного продукта, учитывать, то,
 - как он будет жить
 - как он будет использоваться
 - как он будет поддерживаться
 - как он будет развиваться

# Social idea

Сделать большой опрос на тему, какими бы услугами 
вы бы хотели регулярно пользоваться

Это могло бы показать в каких направлениях нужно больше работать

Например, в моём случае,
- еда
- спортзал
- танцы
- отдых под солнцем, чтобы выглядеть свежее))

Тогда можно было увидеть, например, что запросов на танц залы одно количество,
а возможности его удовлетворить нету, значит, можно построить танц. зал.

# VIM chapters

Make video per vim feature - it will check use cases for that features.

For example, substitute:
1. default substitute
2. replace in file
3. replace in selection
4. replace with regex
5. use captchuring groups
6. use history to repeat
7. put replace into macros
8. apply replace to all files - combination for file search with telescope
9. file search with same regex as replace

# VIM

We wanna rock music on background.

If you really love coding and creating software?
If you love understanding how the things work.
If you prefer to write your styles for a button in 3 minutes,
instead of installing the new library.

Listen (Watch).

What if I tell you that you can just do your work.
And in parallel your body will become stronger?
That is one of the reasons to use the nvim.

You just doing your general work
, with you normal speed
, but your typing
, memory and concetration
, enginnering skills
, you toolset (e.g. editing smth via sh)

just growth for free.

So, start now with installing the vim plugin into your IDE.
After you feel familiar/ready you may try to use nvim.

What I have described happened to me in two years.

Now I am using my own configured instance of nvim.

So, once you are ready - go to that video to see what benefits can provide.

And the process of development has never been so
satisfing, fast and full feel of freedom.

Moreover, I feel like now I am being to able to learn
and understand new tools faster.


