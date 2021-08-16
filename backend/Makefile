GOCMD=go
BIN_FILE=delivery

build: darwin linux windows

darwin:
	mkdir -p out/bin
	GO111MODULE=on
	env GOOS=darwin GOARCH=amd64 $(GOCMD) build -i -v -o out/bin/darwin/$(BIN_FILE)

linux:
	mkdir -p out/bin
	GO111MODULE=on
	env GOOS=linux GOARCH=amd64 $(GOCMD) build -i -v -o out/bin/linux/$(BIN_FILE)

windows:
	mkdir -p out/bin
	GO111MODULE=on
	env GOOS=windows GOARCH=amd64 $(GOCMD) build -i -v -o out/bin/win/$(BIN_FILE)

run:
	./out/bin/darwin/$(BIN_FILE)

test:
	go test ./...

clean:
	rm -rf out
	go clean