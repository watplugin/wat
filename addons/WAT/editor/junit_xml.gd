extends Script

static func write(results, time: float = 0.0) -> void:
	if not ProjectSettings.has_setting("WAT/Results_Directory"):
		print("cannot find directory")
		return
	var path: String = ProjectSettings.get_setting("WAT/Results_Directory")
	if not Directory.new().dir_exists(path):
		Directory.new().make_dir_recursive(path)
	var tests: int = results.size()
	var failures: int = 0
	for i in results:
		if not i.success:
			failures += 1
	var output: String = ""
	output += '<?xml version="1.0" ?>'
	output += '\n<testsuites failures="%s" name="TestXML" tests="%s" time="%s">' % [failures, tests, time]
	for result in results:
		output += '\n\t<testsuite name="%s" failures="%s"  tests="%s" time="%s">' % [result.context, result.total - result.passed, result.total, result.time_taken]
		for case in result.methods:
				output += '\n\t\t<testcase name="%s" time="%s">' % [case.context, case.time]
				for assertion in case.assertions:
					if not assertion.success:
						output += '\n<failure message="EXPECTED: %s but GOT %s"></failure>' % [assertion.expected, assertion.actual]
	# I think these are unnecessary. Will revisit on CLI creation.
				output += '</testcase>' 
		output += "\n\t</testsuite>\n"
	output += '\n</testsuites>'
	var XML = File.new()
	var err = XML.open("%s/results.xml" % path, File.WRITE)
	if err:
		push_warning(err as String)
	XML.store_string(output)
	XML.close()
