# knife-gadgets
A knife plugin that adds hooks to knife to run external scripts at key points and potentially abort the action being taken. 

Install by copying to .chef/plugins/knife/ 

Currently there are two hooks in the 'cookbook upload' command:

1. Before syntax checking (useful for extra checking/linting of cookbooks)
2. After syntax checking has passed but before upload takes place (a good place to commit to SCM etc) 

When the hook code runs it checks if the configuration options 'prevalidate_hook' and 'postvalidate_hook' are set (e.g in knife.rb) and runs the scripts they point to. 

Example knife.rb settings:

```
prevalidate_hook         "/home/user/Chef/prevalidate_cookbook.sh"
postvalidate_hook        "/home/user/Chef/postvalidate_cookbook.sh"
```

Scripts will have the following environment variables set:

```
$CURRENT_COOKBOOK #name of the current cookbook 
$COOKBOOK_PATH #filesystem path to cookbooks
$NODE_NAME #name of client 

```

If a script returns a non-zero exit code the 'cookbook upload' operation is aborted. 

It is planned to add additional hooks over time. 
