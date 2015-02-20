#!/usr/bin/env bats
load test_helper

@test "image build" {

  run build_image
  [ "$status" -eq 0 ]

}

@test "http response" {

  tmp_file="$BATS_TMPDIR/docker-test"
  
  run_image
  wait_service apache2 php5-fpm
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
  DB_CID=$(docker run -e ROOT_ALLOWED_NETWORKS="['172.17.%.%', 'localhost', '127.0.0.1', '::1']" -d osixia/mariadb:0.2.2)
  DB_IP=$(get_container_ip $DB_CID)

  # add default wordpress database and user (must match env.yml)
  wait_service_by_cid $DB_CID mysqld
  docker exec $DB_CID mysql -u admin -padmin mysql -u admin -padmin -e "CREATE DATABASE wordpress;"
  docker exec $DB_CID mysql -u admin -padmin mysql -u admin -padmin -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'172.17.%.%' IDENTIFIED BY 'wp-password' WITH GRANT OPTION ;"

  # run wordpress container and set DB_HOST
  run_image -e DB_HOST=$DB_IP
  wait_service apache2 php5-fpm
  curl -L --silent --insecure https://$CONTAINER_IP >> $tmp_file
  run grep -c ">WordPress<" $tmp_file
  rm $tmp_file
  clear_container

  # clear mariadb container
  clear_container_by_cid $DB_CID

  [ "$status" -eq 0 ]
  [ "$output" = "1" ]

}

@test "http response with existing database" {

  skip

  run_image -v $BATS_TEST_DIRNAME/database:/var/lib/mysql
  wait_service mysqld
  run docker exec $CONTAINER_ID mysql -u admin -padmin --skip-column-names -e "select distinct user from mysql.user where user='existing-hello';"
  clear_container
  UNAME=$(sed -e 's#.*/\(\)#\1#' <<< "$HOME") || true
  chown -R $UNAME:$UNAME $BATS_TEST_DIRNAME/database || true

  [ "$status" -eq 0 ]
  [ "$output" = "existing-hello" ]

}