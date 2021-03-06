#!/bin/bash

TESTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $TESTDIR/../script/test.sh
source $SCRIPTDIR/common.sh
source $SCRIPTDIR/config.sh
source $SCRIPTDIR/pki.sh
source $SCRIPTDIR/consul.sh

KON_SERVERS=swe:swe-east:core-01:$(test::ip_addr_1)
KON_MINIONS=swe:swe-east:core-02:$(test::ip_addr_2)

test::consul::setup_suite () {
    KON_PKI_DIR=$(mktemp -d)
    config::nodes
}

test::consul::setup_test () {
    kon_nameserver="127.0.0.1"
    cert_bundle_name="$(pki::generate_name "consul" "$(test::ip_addr_1)")"
    CONSUL_BIND_INTERFACE="eth0"
    KON_CONSUL_ENCRYPTION_KEY="1"
    CONSUL_VERSION="1.0.0"
    KON_CONSUL_CONFIG_TLS=$KON_PKI_DIR/tls.json
    touch $KON_PKI_DIR/ca.key
    touch $KON_PKI_DIR/ca.crt
    touch $KON_PKI_DIR/$cert_bundle_name.key
    touch $KON_PKI_DIR/$cert_bundle_name.crt
    touch $KON_CONSUL_CONFIG_TLS

    test_name="test::consul::check_start_params"
    NO_LOG=false
}

test::consul::tear_down () {
    rm -rf $KON_PKI_DIR
}

test::consul::check_start_params () {
    

    test::consul::setup_test
    unset kon_nameserver
    out=$(consul::check_start_params)
    assert "kon_nameserver" "${out:28}" "no recursor"

    test::consul::setup_test
    unset CONSUL_BIND_INTERFACE
    out=$(consul::check_start_params)
    assert "CONSUL_BIND_INTERFACE" "${out:28}" "no network interface"

    test::consul::setup_test
    unset KON_CONSUL_ENCRYPTION_KEY
    out=$(consul::check_start_params)
    assert "KON_CONSUL_ENCRYPTION_KEY" "${out:28}" "no encryption key"

    test::consul::setup_test
    unset CONSUL_VERSION
    out=$(consul::check_start_params)
    assert "CONSUL_VERSION" "${out:28}" "no Consul version"

    test::consul::setup_test
    rm $KON_PKI_DIR/ca.crt
    out=$(consul::check_start_params)
    assert "ca cert" "${out:28}" "no ca cert"

    test::consul::setup_test
    rm $KON_PKI_DIR/$cert_bundle_name.crt
    out=$(consul::check_start_params)
    assert "consul cert" "${out:28}" "no $cert_bundle_name cert"

    test::consul::setup_test
    rm $KON_PKI_DIR/$cert_bundle_name.key
    out=$(consul::check_start_params)
    assert "consul key" "${out:28}" "no $cert_bundle_name key"

    test::consul::setup_test
    rm -f $KON_CONSUL_CONFIG_TLS
    out=$(consul::check_start_params)
    assert "TLS config" "${out:28}" "no Consul TLS config"
}

trap test::consul::tear_down EXIT

test::consul::setup_suite

(test::consul::check_start_params)

NO_LOG=true