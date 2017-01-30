import os;
import sys;
import json;
import re;
import getpass

# possible parameters
tag_directory_param = "--tag";
go_to_tag_param 	= "--go";
list_tags_param 	= "--list";

# storage path and system user
current_user = getpass.getuser();
storage_filename = os.path.dirname(__file__) + "/../repository/" + current_user + "-storage.json";

def get_input_from_arguments_by_index( index, important=True ):
# begin
	tag = "";
	try:
		tag = sys.argv[index + 1];
	except IndexError:
		if important:
			print("no tag provided");
			sys.exit(2);
			pass;
		pass;
	return tag;
# end

def load_json_storage ():
# begin
	global data;
	data = json.load(open(storage_filename));
	pass;
# end

def update_json_storage ():
# begin
	global data;
	storage_write_type='w';
	json.dump(data, open(storage_filename, storage_write_type));
	pass;
# end

def create_tag ( tag ):
# begin
	current_dir = os.getcwd();
	data[tag] = current_dir;
	pass;
# end

def find_path_by_tag( tag ):
# begin
	global data;
	path = None;
	try:
		path = data[tag];
	except KeyError:
		print("unknown tag - " + tag);
		sys.exit(1);
	return path;
# end

def process_environment_variables( path ):
# begin
	pattern = '\$\{(.*)\}';
	matches = re.findall(pattern, path, re.DOTALL);
	for match in matches:
		env = os.environ[match];
		path = path.replace("${" + match + "}", env);
	return path;
# end

def process_dr_variables( path ):
# begin
	global data;
	pattern = '\@\{(.*)\}';
	matches = re.findall(pattern, path, re.DOTALL);
	for match in matches:
		env = find_path_by_tag(match);
		path = path.replace("@{" + match + "}", env);
	return path;
# end

# initialize storage
data = None;
try:
	load_json_storage();
except FileNotFoundError:
	data = dict();
	update_json_storage();
	load_json_storage();

# MAIN
# Check paramaters
try:
	# check
	index = sys.argv.index(tag_directory_param);
	# react
	tag = get_input_from_arguments_by_index(index);
	# create tag with current working directory
	create_tag(tag);
	# update json storage file
	update_json_storage();
except ValueError:
	pass;

# Check for go parameter
try:
	index = sys.argv.index(go_to_tag_param);
	#
	tag = get_input_from_arguments_by_index(index);
	# find path in storage
	path = find_path_by_tag(tag);
	# process environment variables
	path = process_environment_variables(path);
	# process local variables
	path = process_dr_variables(path);
	print(path);
except ValueError:
	pass;

# Check for list parameter
tag_list_param_index = None;
try:
	index = sys.argv.index(list_tags_param);
	tag_filter = get_input_from_arguments_by_index(index, False);
	for key in data.keys():
		if (key.startswith(tag_filter)):
			print("[" + key + "] => [" + data[key] + "]");
except ValueError:
	pass;
