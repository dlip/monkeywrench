#!/bin/bash
docker rm -f etcd
docker run -d --name etcd --hostname etcd -v /var/etcd:/var/etcd quay.io/coreos/etcd:v2.3.5 --data-dir '/var/etcd' --listen-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001' --advertise-client-urls 'http://etcd:2379,http://etcd:4001'
