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
  curl -L --silent --insecure https://$CONTAINER_IP >> $tmp_file
  run grep -c "Setup Configuration File" $tmp_file
  rm $tmp_file
  clear_container

  [ "$status" -eq 0 ]
  [ "$output" = "1" ]

}
