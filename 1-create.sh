docker create --privileged --cpus 20 --gpus all \
    -v "$(pwd)"/results:/root/git/blond/results/ \
    --name blond-1.0 kiliakis/blond:1.0
