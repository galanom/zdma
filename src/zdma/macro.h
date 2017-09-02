#pragma once

#define K	(1000)
#define Ki	(1024)
#define M	(K*K)
#define Mi	(Ki*Ki)
#define G	(K*K*K)
#define Gi	(Ki*Ki*Ki)

#define CEIL(x, y)	((x - 1)/y + 1)
//#define ALIGN(x, y)	((x + y - 1) & ~(y - 1))
#define MIN(a,b)	({ __typeof__ (a) _a = (a); __typeof__ (b) _b = (b); _a < _b ? _a : _b; })
#define MAX(a,b)	({ __typeof__ (a) _a = (a); __typeof__ (b) _b = (b); _a > _b ? _a : _b; })

