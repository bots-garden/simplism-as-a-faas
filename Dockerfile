FROM busybox:1.36.1 as initialize

RUN <<EOF
mkdir wasm-files
EOF

FROM k33g/simplism:0.1.2

COPY --from=initialize /wasm-files /wasm-files
COPY simplism-config.yaml .

EXPOSE 7000

CMD ["/simplism", "config", "./simplism-config.yaml", "faas-config"]

#docker images | grep simplism-faas
