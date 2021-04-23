docker run --privileged --cpus 0 --gpus all \
    -v "$(pwd)"/results:/root/results/ \
    --rm -it --name hblond-1.1 kiliakis/hblond:1.1
