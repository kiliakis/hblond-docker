docker run --privileged --cpus 20 --gpus all \
    -v "$(pwd)"/results:/root/results/ \
    --rm -it --name blond-1.0 kiliakis/blond:1.0
