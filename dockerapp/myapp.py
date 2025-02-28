import time
import sys
for x in range(10):
    print("La mia prima app su docker")
    for i in range(1,6):
        print(i)
        sys.stdout.flush()
        time.sleep(5)
    