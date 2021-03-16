objects = build/main.o build/brainfuck.o build/read_file.o
.PHONY: clean

brainfuck: $(objects)
	$(CC) -o "$@" $^ -fPIC -no-pie

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -fPIC -no-pie -c -o "$@" "$<"

clean:
	rm -rf brainfuck build
