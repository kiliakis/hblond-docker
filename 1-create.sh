docker create --privileged --cpus 0 --gpus all \
    -v "$(pwd)"/results:/root/git/blond/results/ \
    --name hblond-1.1 kiliakis/hblond:1.1
