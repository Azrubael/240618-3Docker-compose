# 2024-06-18    09:48
=====================

To run this app you need VirtualBox with setted up Debian11 virtual machine 'docker-lab' (or a sort of).
```bash
./vmstart
cd /home/debian/final-subtask2/
ls -alg
./1-script.sh
cd /opt/docker/final-task2/
docker build
docker compose up -d
```

If the infrastructure was setted up in correct way:
- Petclinic app is accessible from the browser on 8080 port.
- You can see doctors lists and be able to make view/change pet owners list
- Application container status is healthy for the whole lifecycle
- You can check DB image metadata for the hint.
