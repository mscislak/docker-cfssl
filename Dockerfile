FROM alpine:3.7
MAINTAINER Maros Scislak <maros.scislak@gmail.com>

ENV CFSSL_CONFIG ca-config.json
ENV CFSSL_CSR ca-csr.json
ENV CFSSL_DB_CONFIG db-config.json

RUN cd /tmp \
	&& wget -q https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
	&& echo -e "eb34ab2179e0b67c29fd55f52422a94fe751527b06a403a79325fed7cf0145bd  cfssl_linux-amd64" | sha256sum -c - \
	&& chmod +x cfssl_linux-amd64 \
	&& mv cfssl_linux-amd64 /usr/local/bin/cfssl \
	&& wget -q https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 \
	&& echo -e "1c9e628c3b86c3f2f8af56415d474c9ed4c8f9246630bd21c3418dbe5bf6401e  cfssljson_linux-amd64" | sha256sum -c - \
	&& chmod +x cfssljson_linux-amd64 \
	&& mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

VOLUME [ "/etc/cfssl" ]

WORKDIR /etc/cfssl

EXPOSE 8080

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "cfssl", "serve", "-address=0.0.0.0", "-port=8080", "-ca=ca.pem", "-ca-key=ca-key.pem" ]
