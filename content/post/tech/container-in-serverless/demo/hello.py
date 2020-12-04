def main(args):
    name = args.get("name", "world")
    return { "body": "Python: Hello, %s"%name }
