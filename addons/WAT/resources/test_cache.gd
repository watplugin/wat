extends Resource
class_name TestCache
tool
# We'll cache loaded scripts and metadata seperately
# This will allow us to load the scripts into memory faster..
# ..but not at the risk of losing metadata if bad load
export(Array) var scripts = []
