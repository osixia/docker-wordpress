setup() {
  IMAGE_NAME="$NAME:$VERSION"
}

# function relative to the current container / image  
build_image() {
  #disable outputs
  docker build -t $IMAGE_NAME $BATS_TEST_DIRNAME/../image &> /dev/null
}

run_image() {
  CONTAINER_ID=$(docker run $@ -d $IMAGE_NAME)
  CONTAINER_IP=$(get_container_ip $CONTAINER_ID)
}

start_container() {
  start_container_by_cid $CONTAINER_ID
}

stop_container() {
  stop_container_by_cid $CONTAINER_ID
}

remove_container() {
 remove_container_by_cid $CONTAINER_ID
}

clear_container() {
  stop_container_by_cid $CONTAINER_ID
  remove_container_by_cid $CONTAINER_ID
}

is_service_running() {
  is_service_running_by_cid $CONTAINER_ID $1
}

wait_service() {
  wait_service_by_cid $CONTAINER_ID $@
}


# generic functions 
get_container_ip() {
   local IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $1)
   echo "$IP"
}

start_container_by_cid() {
  #disable outputs
  docker start $1 &> /dev/null
}

stop_container_by_cid() {
  #disable outputs
  docker stop $1 &> /dev/null
}

remove_container_by_cid() {
  #disable outputs
 docker rm $1 &> /dev/null
}

clear_container_by_cid() {
  for cid in "$@"
  do
    stop_container_by_cid $cid
    remove_container_by_cid $cid
  done
}

is_service_running_by_cid() {
  docker exec $1 ps cax | grep $2  > /dev/null
}

wait_service_by_cid() {

  cid=$1

  # first wait image init end
  while ! is_service_running syslog-ng
  do
    sleep 1
  done

  for service in "${@:2}"
  do
    # wait service
    while ! is_service_running_by_cid $cid $service
    do
      sleep 1
    done
  done

  sleep 5
}