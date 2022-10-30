FROM golang:1.19.1-buster as builder

RUN apt-get update && apt-get install -y wget
ADD . /tag
WORKDIR /tag/cmd/sum
RUN go build
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp3/mopt/1.mp3
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp3/mopt/112.mp3
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp3/mopt/116.mp3
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp3/mopt/121.mp3

FROM golang:1.19.1-buster
COPY --from=builder /tag/cmd/sum/sum /
COPY --from=builder /tag/cmd/sum/*.mp3 /testsuite/

ENTRYPOINT []
CMD ["/sum", "@@"]
