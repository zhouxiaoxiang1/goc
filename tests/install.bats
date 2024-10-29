#!/usr/bin/env bats
# Copyright 2020 Qiniu Cloud (七牛云)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load util.sh

setup_file() {
    # run centered server
    goc server 3>&- &
    GOC_PID=$!
    sleep 2
    goc init

    info "goc server started"
}

teardown_file() {
    kill -9 $GOC_PID
}

setup() {
    goc init
}

@test "test basic goc install command" {
    info $PWD
    export GOPATH=$PWD/samples/simple_gopath_project
    export GO111MODULE=off
    cd samples/simple_gopath_project/src/qiniu.com/simple_gopath_project

    wait_profile_backend "install1" &
    profile_pid=$!

    run gocc install --debug --debugcisyncfile ci-sync.bak;
    info install1 output: $output
    [ "$status" -eq 0 ]

    wait $profile_pid
}

@test "test basic goc install command with GOBIN set" {
    info $PWD
    export GOPATH=$PWD/samples/simple_gopath_project
    export GOBIN=$PWD
    export GO111MODULE=off
    cd samples/simple_gopath_project/src/qiniu.com/simple_gopath_project

    wait_profile_backend "install2" &
    profile_pid=$!

    run gocc install --debug --debugcisyncfile ci-sync.bak;
    info install2 output: $output
    [ "$status" -eq 0 ]

    wait $profile_pid
}

@test "test goc install command with multi-mains project" {
    cd samples/multi_mains_project_with_internal
    info $PWD
    export GOBIN=$PWD
    export GO111MODULE=on

    wait_profile_backend "install3" &
    profile_pid=$!

    run gocc install ./... --debug --debugcisyncfile ci-sync.bak;
    info install3 output: $output
    [ "$status" -eq 0 ]

    run ls -al 
    info install3 ls output: $output

    [[ -f main1 ]]
    [[ -f main2 ]]

    wait $profile_pid
}
