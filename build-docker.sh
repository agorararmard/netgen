mkdir -p logs/docker
echo "dir created"
docker build --rm -t netgen . | tee logs/docker/netgen.build.txt

