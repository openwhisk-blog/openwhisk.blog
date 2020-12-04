package main

// Main function
func Main(args map[string]interface{}) map[string]interface{} {
	name, ok := args["name"].(string)
	if !ok {
		name = "world"
	}
	return map[string]interface{}{
		"body": "Go: Hello " + name,
	}
}
