// a javascript function

function main(args) {
    let name = args.name || "world";
    return {
        "body": "JS: Hello, "+name
    }
}