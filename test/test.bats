#!/usr/bin/env bats
load test_helper

@test "image build" {

  run build_image
  [ "$status" -eq 0 ]

}

@test "http response" {

  tmp_file="$BATS_TMPDIR/docker-test"

  run_image
  wait_process apache2 php5-fpm
  curl --silent --insecure https://$CONTAINER_IP >> $tmp_file
  run grep -c "Error establishing a database connection" $tmp_file
  rm $tmp_file
  clear_container

  [ "$status" -eq 0 ]
  [ "$output" = "1" ]

}

@test "http response with new database" {

  tmp_file="$BATS_TMPDIR/docker-test"

  # we start a new mariadb container
  DB_CID=$(docker run -e ROOT_ALLOWED_NETWORKS="['172.17.%.%', 'localhost', '127.0.0.1', '::1']" -d osixia/mariadb:0.2.7)
  DB_IP=$(get_container_ip_by_cid $DB_CID)

  # we start the wordpress container and set DB_HOST
  run_image -e DB_HOST=$DB_IP

  # add default wordpress database and user (must match env.yml)
  wait_process_by_cid $DB_CID mysqld
  docker exec $DB_CID mysql -u admin -padmin mysql -u admin -padmin -e "CREATE DATABASE wordpress;"
  docker exec $DB_CID mysql -u admin -padmin mysql -u admin -padmin -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'172.17.%.%' IDENTIFIED BY 'wp-password' WITH GRANT OPTION ;"

  # wait wordpress container apache2 service
  wait_process apache2 php5-fpm
  curl -L --silent --insecure https://$CONTAINER_IP >> $tmp_file
  run grep -c ">WordPress<" $tmp_file
  rm $tmp_file
  clear_container

  # clear mariadb container
  clear_containers_by_cid $DB_CID

  [ "$status" -eq 0 ]
  [ "$output" = "1" ]

}

@test "http response with existing database" {

  tmp_file="$BATS_TMPDIR/docker-test"

  # we start a new mariadb container
  DB_CID=$(docker run -v $BATS_TEST_DIRNAME/database:/var/lib/mysql -d osixia/mariadb:0.2.7)
  DB_IP=$(get_container_ip_by_cid $DB_CID)

  # we start the wordpress container and set DB_HOST
  run_image -e DB_HOST=$DB_IP

  # wait wordpress container apache2 service
  wait_process apache2 php5-fpm
  curl -L --silent --insecure https://$CONTAINER_IP >> $tmp_file
  run grep -c "Osixia Docker Wordpress !" $tmp_file
  rm $tmp_file
  clear_container

  # clear mariadb container
  clear_containers_by_cid $DB_CID

  UNAME=$(sed -e 's#.*/\(\)#\1#' <<< "$HOME") || true
  chown -R $UNAME:$UNAME $BATS_TEST_DIRNAME || true

  [ "$status" -eq 0 ]
  [ "$output" = "3" ]

}
