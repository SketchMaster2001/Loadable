# Loadable
Swift package that loads primitive data types into structs akin to Golang

### In Golang, you are able to store data into structs by using `binary.Read()` like so
```go
type Foobar struct {
    A   uint8
    B   [1]byte
    C   [10]byte
}

func LoadFoobar() error {
    contents := []byte{1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}
    var foobar Foobar
    buf := bytes.NewBuffer(contents)
    err := binary.Read(buf, binary.BigEndian, &foobar)
    
    if err != nil {
        return err
    }
    
    fmt.Println(foobar.a)
    fmt.Println(foobar.b)
    fmt.Println(foobar.c)
}
```

Prints:
```
1
[2]
[4 4 4 4 4 4 4 4 4 4]
```

In Swift, there is no native way to do this. The Loadable protocol aims to fix this.

## How to use

### First off, you will need your struct to conform to Decodable then Loadable. This is because while Loadable can handle many Decodable types such as Int's and Int arrays, it cannot with types with unfixed sizes such as strings or dictionaries.
```swift
struct Foobar: Loadable {
    var a: uint8?
    var b: uint8?
    var c = Array<uint8>(repeating: 0, count: 10)
    
    init() {}
}

func loadFoobar() {
    let contents = Data([1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4])
    
    // You should never be forcing try to succeed, I am only doing this as I know it will work
    let foobar = try! Foobar().load(Foobar.self, contents, endianess: .bigEndian)
    
    print(foobar.a)
    print(foobar.b)
    print(foobar.c)
}
``` 

Prints:
```
1
2
[4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
```

## Data Types should be optional
You should make your data types in the struct be optional as you do not need to feed a value to init them. The only exception to this is `Array<UInt8>` as the array needs a fixed size for Loadable to read. 
