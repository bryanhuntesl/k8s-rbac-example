#!/usr/bin/env python3

from bottle import route, run, response, request
import json
import requests


@route('/reader/v1/pods')
def index():
    namespace = cat('/var/run/secrets/kubernetes.io/serviceaccount/namespace')
    k8s_url = f'https://kubernetes.default.svc.cluster.local/api/v1/namespaces/{namespace}/pods'
    ca_crt = '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
    token = cat('/var/run/secrets/kubernetes.io/serviceaccount/token')
    headers = {
        'Authorization': f'Bearer {token}'
    }
    k8s_resp = requests.get(k8s_url, params=request.query,
                            verify=ca_crt, headers=headers)
    response.status = k8s_resp.status_code
    return json.dumps(k8s_resp.json(), indent=4, sort_keys=True)


def cat(path):
    with open(path) as f:
        return f.read()


if __name__ == '__main__':
    run(host='0.0.0.0', port=8080, debug=True)
