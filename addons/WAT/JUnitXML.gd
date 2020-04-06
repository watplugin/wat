extends Reference

func save(results, time: float = 0.0) -> void:
	var tests: int = results.size()
	var failures: int = 0
	for i in results:
		if not i.success:
			failures += 1
	var output: String = ""
	output += '<?xml version="1.0" ?>'
	output += '\n<testsuites failures="%s" name="TestXML" tests="%s" time="%s">' % [failures, tests, time]
	for result in results:
		output += '\n<testsuite failures="%s" name="%s" tests="%s" time= "%s">' % [result.total - result.passed, result.context, result.total, result.time_taken]
		for case in result.methods:
			if not case.success:
				output += '\n<testcase name="%s" time="%s">' % [case.context, case.time]
				for assertion in case.assertions:
					if not assertion.success:
						output += '\n<failure message="%s"> EXPECTED: %S | GOT %s</failure/' % [assertion.context, assertion.expected, assertion.actual]
				output += '\n</testcase>' 
		output += "\n</testsuite>"
	output += '\n</testsuites>'
	var XML = File.new()
	XML.open("res://tests/results/results.xml", File.WRITE)
	XML.store_string(output)
	XML.close()

#func display_failures(case) -> void:
#	print("%s (%s)" % [case.context, case.path])
#	for method in case.methods:
#		if not method.success:
#			print("\n  %s" % method.context)
#			for assertion in method.assertions:
#				if not assertion.success:
#					print("\t%s" % assertion.context, "\n\t  (EXPECTED: %s) | (RESULTED: %s)" % [assertion.expected, assertion.actual])
