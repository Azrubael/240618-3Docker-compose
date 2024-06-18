#!/usr/bin/env python3

import subprocess
import json

output = subprocess.run(['docker', 'compose', 'config', '--format', 'json'], capture_output=True, text=True).stdout

config = json.loads(output)

if config['services']['frontend']['depends_on']['mydb']['condition'] == "service_healthy" and config['services']['frontend']['depends_on']['mydb']['required'] == True :
    print("'frontend' service depends on 'mydb' service")
else:
    print("'frontend' service doesn't depend on 'mydb' service")
