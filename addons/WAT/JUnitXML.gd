extends Reference

func save(results) -> void:
	var tests: int = results.size()
	var failures: int = 0
	for i in results:
		if not i.success:
			failures += 1
	var output: String = ""
	output += '<?xml version="1.0" ?>'
	output += '\n<testsuites failures="%s" name="TestXML" tests="%s" time="1">' % [failures, tests]
	for result in results:
		output += '\n<testsuite failures="%s" name="%s" tests="%s" time= "1">' % [result.total - result.passed, result.context, result.total]
		for case in result.methods:
			output += '\n<testcase name="%s" time="1">' % case.context
			output += '\n</testcase>' 
		output += "\n<testsuite>"
	output += '\n</testsuites>'
	var XML = File.new()
	XML.open("Results.XML", File.WRITE)
	XML.store_string(output)
	XML.close()

#	methods.append({context = description, assertions = [], total = 0, passed = 0, success = false})
