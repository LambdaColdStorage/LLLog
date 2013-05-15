# Setup

```
LambdaLabsLambdaLabsLamb
a                      d
m                      a
b        \\            L
d         \\           a
a          \\          b
L         //\\         s
a        //  \\        L
b       //    \\       a
s                      m
L                      b
ambdaLabsLambdaLabsLambd
```

Usage:
	1) Toggle from 0 -> 1 to enable an analytics platform.
	2) #define LL_YOUR_<PLATFORM>_TOKEN in LLTokens.h where <PLATFORM> in { GA, MIXPANEL, FLURRY }
	3) Done!

Optional:
	4) Use the logKey:withProperties, logUserKey:incrementBy:, and logError:withProperties to log
	events in your app!

