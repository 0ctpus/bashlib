# library for shell script

Usage
-------------------
1.import air.sh

```bash
#!/usr/bin/env bash

# read air.sh
dir=$(dirname $(readlink -f $0)) && if [ -e ${dir}/air.sh ]; then . ${dir}/air.sh; else echo "error" && exit; fi
```
