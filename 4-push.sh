#/bin/bash
docker tag kiliakis/hblond:1.1 172.9.0.240:5000/hblond:1.1
cat ~/EVOLVE/requirements_setup/password_stdin.txt | docker login 172.9.0.240:5000 --username evolve --password-stdin
docker push 172.9.0.240:5000/hblond:1.1
