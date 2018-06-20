#!/bin/ash
set -e

if [ ! -f "${CFSSL_CONFIG}" ]; then
	cfssl print-defaults config > ${CFSSL_CONFIG}
fi

if [ ! -f "${CFSSL_CSR}" ]; then
	cfssl print-defaults csr > ${CFSSL_CSR}
fi

if [ ! -f "ca.pem" ] || [ ! -f "ca-key.pem" ]; then
	cfssl gencert -initca -config=${CFSSL_CONFIG} ${CFSSL_CSR} | cfssljson -bare ca -	
fi

if [ "${1}" = "cfssl" ]; then

	if [ -f "${CFSSL_CONFIG}" ]; then
		set -- "$@" -config=${CFSSL_CONFIG}
	fi

	if [ "${2}" = "serve" ]; then
		if [ -f "${CFSSL_DB_CONFIG}" ]; then
			set -- "$@" -db-config=${CFSSL_DB_CONFIG}
		fi
	fi
	
fi

exec "$@"